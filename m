From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Fixing gave up waiting for init of module libcrc32c.
Date: Tue, 30 Mar 2010 09:36:57 +1030
Message-ID: <201003300936.58300.rusty@rustcorp.com.au>
References: <20100320010849.GA30654@gondor.apana.org.au> <20100319.222325.260105122.davem@davemloft.net> <20100320122959.GA1930@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, brandon@ifup.org,
	linux-crypto@vger.kernel.org, Tim Abbott <tabbott@mit.edu>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:60377 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014Ab0C2XHD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Mar 2010 19:07:03 -0400
In-Reply-To: <20100320122959.GA1930@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, 20 Mar 2010 10:59:59 pm Herbert Xu wrote:
> On Fri, Mar 19, 2010 at 10:23:25PM -0700, David Miller wrote:
> >
> > I hear what you're saying Herbert, but thinking about this a bit I
> > really think we should make this situation work instead of fail.
> 
> I think the initial report perhaps painted this in a slight
> different fashion than what it really is.  The code that was
> looping in module.c is not trying to load libcrc32c, but rather
> it is trying to get a reference on the already-loaded libcrc32c
> module.
> 
> AFAICS the only way to make it "work" would be to reload the
> module in question when we can't get a reference on it.  But
> that would entail recursively loading a module during the process
> of loading another module.
> 
> Rusty can chime in on whether this is doable.

Not really.  The kernel code is pretty simple: if we can't find a symbol
we need, fail the load.  To avoid nasty spurious races, we *do* wait if the
symbol we need is in a module which is still initializing.  But we time out
after 30 seconds to avoid a module trainwreck.

The real fix here is to drop the lock, like Brandon suggested, but we need
to do it more carefully: when we re-acquire the lock we need to re-lookup
the symbol in case the module has vanished or changed.

Brandon, I can't see how libcrc32c's module_init calls crypto_alloc_shash,
but the problem is reproducible with simple example modules.  Does it fix
your problem?

Tim: note that use_module() return value changes.

Thanks,
Rusty.

module: drop the lock while waiting for module to complete initialization.

This fixes "gave up waiting for init of module libcrc32c." which
happened at boot time due to multiple parallel module loads.

The problem was a deadlock: we wait for a module to finish
initializing, but we keep the module_lock mutex so it can't complete.
In particular, this could reasonably happen if libcrc32c does a
request_module() in its initialization routine.

So we change use_module() to return an errno rather than a bool, and if
it's -EBUSY we drop the lock and wait in the caller, then reaquire the
lock.

Reported-by: Brandon Philips <brandon@ifup.org>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff --git a/kernel/module.c b/kernel/module.c
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -510,33 +510,25 @@ int use_module(struct module *a, struct 
 	struct module_use *use;
 	int no_warn, err;
 
-	if (b == NULL || already_uses(a, b)) return 1;
+	if (b == NULL || already_uses(a, b)) return 0;
 
 	/* If we're interrupted or time out, we fail. */
-	if (wait_event_interruptible_timeout(
-		    module_wq, (err = strong_try_module_get(b)) != -EBUSY,
-		    30 * HZ) <= 0) {
-		printk("%s: gave up waiting for init of module %s.\n",
-		       a->name, b->name);
-		return 0;
-	}
-
-	/* If strong_try_module_get() returned a different error, we fail. */
+	err = strong_try_module_get(b);
 	if (err)
-		return 0;
+		return err;
 
 	DEBUGP("Allocating new usage for %s.\n", a->name);
 	use = kmalloc(sizeof(*use), GFP_ATOMIC);
 	if (!use) {
 		printk("%s: out of memory loading\n", a->name);
 		module_put(b);
-		return 0;
+		return -ENOMEM;
 	}
 
 	use->module_which_uses = a;
 	list_add(&use->list, &b->modules_which_use_me);
 	no_warn = sysfs_create_link(b->holders_dir, &a->mkobj.kobj, a->name);
-	return 1;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(use_module);
 
@@ -823,7 +815,7 @@ static inline void module_unload_free(st
 
 int use_module(struct module *a, struct module *b)
 {
-	return strong_try_module_get(b) == 0;
+	return strong_try_module_get(b);
 }
 EXPORT_SYMBOL_GPL(use_module);
 
@@ -994,17 +986,39 @@ static const struct kernel_symbol *resol
 	struct module *owner;
 	const struct kernel_symbol *sym;
 	const unsigned long *crc;
+	DEFINE_WAIT(wait);
+	int err;
+	long timeleft = 30 * HZ;
 
+again:
 	sym = find_symbol(name, &owner, &crc,
 			  !(mod->taints & (1 << TAINT_PROPRIETARY_MODULE)), true);
-	/* use_module can fail due to OOM,
-	   or module initialization or unloading */
-	if (sym) {
-		if (!check_version(sechdrs, versindex, name, mod, crc, owner)
-		    || !use_module(mod, owner))
-			sym = NULL;
+	if (!sym)
+		return NULL;
+
+	if (!check_version(sechdrs, versindex, name, mod, crc, owner))
+		return NULL;
+
+	prepare_to_wait(&module_wq, &wait, TASK_INTERRUPTIBLE);
+	err = use_module(mod, owner);
+	if (likely(!err) || err != -EBUSY || signal_pending(current)) {
+		finish_wait(&module_wq, &wait);
+		return err ? NULL : sym;
 	}
-	return sym;
+
+	/* Module is still loading.  Drop lock and wait. */
+	mutex_unlock(&module_mutex);
+	timeleft = schedule_timeout(timeleft);
+	mutex_lock(&module_mutex);
+	finish_wait(&module_wq, &wait);
+
+	/* Module might be gone entirely, or replaced.  Re-lookup. */
+	if (timeleft)
+		goto again;
+
+	printk("%s: gave up waiting for init of module %s.\n",
+	       mod->name, owner->name);
+	return NULL;
 }
 
 /*

