Return-Path: <SRS0=rMEF=NS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mail-qk1-f196.google.com ([209.85.222.196]:35469 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727592AbeKHFVP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Nov 2018 00:21:15 -0500
Received: by mail-qk1-f196.google.com with SMTP id v68-v6so22592233qka.2
        for <linux-crypto@vger.kernel.org>; Wed, 07 Nov 2018 11:49:24 -0800 (PST)
Message-ID: <1541620162.4051.5.camel@redhat.com>
Subject: Re: [Qestion] Lots of memory leaks when mounting and unmounting nfs
 client to server continuously.
From: Dave Wysochanski <dwysocha@redhat.com>
To: zhong jiang <zhongjiang@huawei.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        herbert@gondor.apana.org.au, trond.myklebust@hammerspace.com,
        bfields@redhat.com
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-nfs@vger.kernel.org
Date: Wed, 07 Nov 2018 14:49:22 -0500
In-Reply-To: <5BD86392.7070200@huawei.com>
References: <5BD85266.6000301@huawei.com>
         <1DEE371C-69EB-4D92-8F78-535AA5203007@redhat.com>
         <5BD86392.7070200@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2018-10-30 at 21:58 +0800, zhong jiang wrote:
> On 2018/10/30 21:06, Benjamin Coddington wrote:
> > Hi zhong jiang,
> > 
> > Try asking in linux-nfs.. but I'll also note that 3.10-stable may
> > be missing a number of fixes to leaks in the NFS GSS code.
> > 
> > I can see a more than a few fixes to memory leaks with:
> > git log --grep=leak --oneline net/sunrpc/auth_gss/
> > 
> 
> Thanks for your reply.  I has tested some of them in the upsteam as
> you have said.  but It fails to solve the issue completely.
> hence, I turn to the relevant experts whether they have happened to
> the issue or  can give some suggestion or not.
> 
> Thanks,
> zhong jiang
> > Ben
> > 
> > On 30 Oct 2018, at 8:45, zhong jiang wrote:
> > 
> > > Hi,   Herbert
> > > 
> > > Recently,  I  hit  a memory leak issue when  mounting and
> > > unmounting nfs with  the way of  krb5.
> > > The issue happens to the linux-3.10-stable.
> > > 
> > > I find that slab-1024 and slab-512 will take up most of the
> > > memory.  And it can not be freed.
> > > Meanwhile, it result in rpcsec_gss_krb5 can be unregistered as
> > > well.
> > > 
> > > 

Are you running the latest 3.10-stable?

This sounds very familiar to something I encountered a while ago and it
was a sunrpc cache related problem.  The patch that fixed it for me is
in 3.10.106 though.

Can you check if this cache is growing indefinitely?
/proc/net/rpc/auth.rpcsec.context

If it is large, try to flush explicitly with:
date +%s  > /proc/net/rpc/auth.rpcsec.context/flush

If all that checks out, you may need the below upstream fix, but it
went into v3.10.106 as
6a4a5fd svcrpc: don't leak contexts on PROC_DESTROY

commit 6a4a5fd4c7bc6a06ca26ad7327d046d8d3c0932a
Author: J. Bruce Fields <bfields@redhat.com>
Date:   Mon Jan 9 17:15:18 2017 -0500

    svcrpc: don't leak contexts on PROC_DESTROY
    
    commit 78794d1890708cf94e3961261e52dcec2cc34722 upstream.
    
    Context expiry times are in units of seconds since boot, not unix time.
    
    The use of get_seconds() here therefore sets the expiry time decades in
    the future.  This prevents timely freeing of contexts destroyed by
    client RPC_GSS_PROC_DESTROY requests.  We'd still free them eventually
    (when the module is unloaded or the container shut down), but a lot of
    contexts could pile up before then.
    
    Fixes: c5b29f885afe "sunrpc: use seconds since boot in expiry cache"
    Reported-by: Andy Adamson <andros@netapp.com>
    Signed-off-by: J. Bruce Fields <bfields@redhat.com>
    Signed-off-by: Willy Tarreau <w@1wt.eu>

diff --git a/net/sunrpc/auth_gss/svcauth_gss.c b/net/sunrpc/auth_gss/svcauth_gss.c
index 62663a0..e625efe 100644
--- a/net/sunrpc/auth_gss/svcauth_gss.c
+++ b/net/sunrpc/auth_gss/svcauth_gss.c
@@ -1518,7 +1518,7 @@ static void destroy_use_gss_proxy_proc_entry(struct net *net) {}
        case RPC_GSS_PROC_DESTROY:
                if (gss_write_verf(rqstp, rsci->mechctx, gc->gc_seq))
                        goto auth_err;
-               rsci->h.expiry_time = get_seconds();
+               rsci->h.expiry_time = seconds_since_boot();
                set_bit(CACHE_NEGATIVE, &rsci->h.flags);
                if (resv->iov_len + 4 > PAGE_SIZE)
                        goto drop;
