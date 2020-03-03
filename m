Return-Path: <SRS0=HdEo=4U=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6488FC3F2D1
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 22:43:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3618720866
	for <linux-crypto@archiver.kernel.org>; Tue,  3 Mar 2020 22:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1583275410;
	bh=KFjLsAjNMx93cGKtEJs8LhZSNNLzN16FDXVUS6jWAAE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fRo6a2lznGVbr0pkaBoPorMadhHlmkBktjMQbRPcDHjpfeQYL6122fC2lbiHQZfHW
	 1wDVDcyN9sNaF9O2C09AGtXHndDIScZ9IHOwvBcNTGhb9BgXyU75jLzFHybKA63gD/
	 7mi9FXQ7nra4BFA/TD+SvkCMXmzCp4NDq7/UfekY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgCCWn3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 3 Mar 2020 17:43:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgCCWn3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 3 Mar 2020 17:43:29 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F5FA2072A;
        Tue,  3 Mar 2020 22:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583275409;
        bh=KFjLsAjNMx93cGKtEJs8LhZSNNLzN16FDXVUS6jWAAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZhVCtl27YLCVh26NOG29luP24Nwr1QwpbSdL/Au+gj/hlBRXXRszO62kMZZurPkJe
         K1BrNOGlz20BT+GWY8ROBP0fNu/hrykd4dM4TF3Tcq6JEnIKx1efyaFDo2k3BYq+RR
         tpliTFwHGaFHXqniA2LtPiF4MSV/eFCa2PLapnaI=
Date:   Tue, 3 Mar 2020 14:43:27 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Robin Murphy <robin.murphy@arm.com>,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        mark.rutland@arm.com, jiangshanlai@gmail.com,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        tj@kernel.org, Will Deacon <will@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20200303224327.GA89804@sol.localdomain>
References: <20200217204803.GA13479@Red>
 <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
 <20200220090350.GA19858@Red>
 <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
 <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
 <20200301175351.GA11684@Red>
 <20200302172510.fspofleipqjcdxak@ca-dmjordan1.us.oracle.com>
 <e7c92da2-42c0-a97d-7427-6fdc769b41b9@arm.com>
 <20200303213017.tanczhqd3nhpeeak@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200303213017.tanczhqd3nhpeeak@ca-dmjordan1.us.oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 03, 2020 at 04:30:17PM -0500, Daniel Jordan wrote:
> On Mon, Mar 02, 2020 at 06:00:10PM +0000, Robin Murphy wrote:
> > On 02/03/2020 5:25 pm, Daniel Jordan wrote:
> > Something smelled familiar about this discussion, and sure enough that merge
> > contains c4741b230597 ("crypto: run initcalls for generic implementations
> > earlier"), which has raised its head before[1].
> 
> Yep, that looks suspicious.
> 
> The bisect didn't point to that specific commit, even though my version of git
> tries commits in the merge.  I'm probably missing something.
> 
> > > Does this fix it?  I can't verify but figure it's worth trying the simplest
> > > explanation first, which is that the work isn't initialized by the time it's
> > > queued.
> > 
> > The relative initcall levels would appear to explain the symptom - I guess
> > the question is whether this represents a bug in a particular test/algorithm
> > (as with the unaligned accesses) or a fundamental problem in the
> > infrastructure now being able to poke the module loader too early.
> 
> I'm not familiar with the crypto code.  Could it be that the commit moved some
> request_module() calls before modules_wq_init()?
> 
> And, is it "too early" or just "earlier"?  When is it too early for modprobe?
> 
> Barring other ideas, Corentin, would you be willing to boot with
> 
>     trace_event=initcall:*,module:* trace_options=stacktrace
> 
> and
> 
> diff --git a/kernel/module.c b/kernel/module.c
> index 33569a01d6e1..393be6979a27 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -3604,8 +3604,11 @@ static noinline int do_init_module(struct module *mod)
>  	 * be cleaned up needs to sync with the queued work - ie
>  	 * rcu_barrier()
>  	 */
> -	if (llist_add(&freeinit->node, &init_free_list))
> +	if (llist_add(&freeinit->node, &init_free_list)) {
> +		pr_warn("%s: schedule_work for mod=%s\n", __func__, mod->name);
> +		dump_stack();
>  		schedule_work(&init_free_wq);
> +	}
>  
>  	mutex_unlock(&module_mutex);
>  	wake_up_all(&module_wq);
> 
> but not my earlier fix and share the dmesg and ftrace output to see if the
> theory holds?
> 
> Also, could you attach your config?  Curious now what your crypto options look
> like after fiddling with some of them today while trying and failing to see
> this on x86.
> 

Probably the request_module() is coming from the registration-time crypto
self-tests allocating the generic implementation of algorithm when an
architecture-specific implementation is registered.  This occurs when
CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y on Linux v5.2 and later.

If this is causing problems we could do:

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index ccb3d60729fc..d89791700b88 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1667,7 +1667,7 @@ static int test_hash_vs_generic_impl(const char *driver,
 	if (strcmp(generic_driver, driver) == 0) /* Already the generic impl? */
 		return 0;
 
-	generic_tfm = crypto_alloc_shash(generic_driver, 0, 0);
+	generic_tfm = crypto_alloc_shash(generic_driver, 0, CRYPTO_NOLOAD);
 	if (IS_ERR(generic_tfm)) {
 		err = PTR_ERR(generic_tfm);
 		if (err == -ENOENT) {
@@ -2389,7 +2389,7 @@ static int test_aead_vs_generic_impl(struct aead_extra_tests_ctx *ctx)
 	if (strcmp(generic_driver, driver) == 0) /* Already the generic impl? */
 		return 0;
 
-	generic_tfm = crypto_alloc_aead(generic_driver, 0, 0);
+	generic_tfm = crypto_alloc_aead(generic_driver, 0, CRYPTO_NOLOAD);
 	if (IS_ERR(generic_tfm)) {
 		err = PTR_ERR(generic_tfm);
 		if (err == -ENOENT) {
@@ -2993,7 +2993,7 @@ static int test_skcipher_vs_generic_impl(const char *driver,
 	if (strcmp(generic_driver, driver) == 0) /* Already the generic impl? */
 		return 0;
 
-	generic_tfm = crypto_alloc_skcipher(generic_driver, 0, 0);
+	generic_tfm = crypto_alloc_skcipher(generic_driver, 0, CRYPTO_NOLOAD);
 	if (IS_ERR(generic_tfm)) {
 		err = PTR_ERR(generic_tfm);
 		if (err == -ENOENT) {


... but that's not ideal, since it would mean that if someone builds all crypto
algorithms as modules, then the comparison tests could be unnecessarily skipped.

But it is really always wrong to be calling request_module() from other
module_init() functions?  The commit that added 'init_free_wq' was also
introduced in v5.2; maybe that's the problem here?

	commit 1a7b7d9220819afe79d1ec5d759fe4349bd2453e
	Author: Rick Edgecombe <rick.p.edgecombe@intel.com>
	Date:   Thu Apr 25 17:11:37 2019 -0700

	    modules: Use vmalloc special flag

- Eric
