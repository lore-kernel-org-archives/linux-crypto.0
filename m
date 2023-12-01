Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="oHYLDcwx"
X-Greylist: delayed 729 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 01 Dec 2023 04:03:06 PST
Received: from out203-205-221-164.mail.qq.com (out203-205-221-164.mail.qq.com [203.205.221.164])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50956199D
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 04:03:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1701432184; bh=tR8Z14YWbuTNzUeB6Tb0dthkFikc6jE+OEIqCFDJYcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oHYLDcwxmiPov0IgAgCmE8AFOBPlhLVtV5i5DnskiSOyoSvaiRgCNlc5irEJfjGhw
	 KCQbSqU+tfBOVRxVifn3Th4ztphHJ5CEVLa3ohB8YMfLvKwGxEZUsJiqZ6oSmKM2Lm
	 B1FdTExs5BfEHw/e2CKMiV6BEBKk1kMfr70tCoyQ=
Received: from pek-lxu-l1.wrs.com ([111.198.228.56])
	by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
	id 966A06D4; Fri, 01 Dec 2023 19:37:38 +0800
X-QQ-mid: xmsmtpt1701430658tmgnveby4
Message-ID: <tencent_0AD55DB29954CFB30D9825850DEE12325D07@qq.com>
X-QQ-XMAILINFO: NR+Rloh0s0m6Z/2rHphXFKzV/Iiix6OPITg6Km2yd+NhQbXFAf6+VSLLcAjTau
	 Ott/RzuJ9VGorZJ163XWFQJO13gDG9GuFL+XJnbRkH5iyDMn65cWeRLMB1GJDo+YIg1gAzW95T1b
	 V7SuBAQ9njmtHWIxEmfZCBfKE/1mdAkiQJkb5f7dn0bvQg9yp3Q7u/ZTlFiyV57i7G6nD/CSjpdA
	 gSUwkehK56xOzJcn2NFIojDon/crAMeS4SsePSX4I0E6JUoXY5cHe7bbRkg14xGKpElfs39Jmujc
	 VN3g1a76qnfGGAci7rb9jXcSBIl68JfqrNjr+H9mQoxy9ALXBW2gOWFpHluEw1uso4+/G24nuXvF
	 kcwIADmWQs73MOle2Gr/+L5aie+XQhBgjEcVCVNUSXd7+/EkdLfIAbKD4gVVe16aw39NUhz+FPKR
	 G/oBGtNtD8Y3QdMSnRFx0EkXi/YQud5MteUwSQCo7VOH6pmRD7wk+jmcYjHkCyTdw/y1LzvzgYtn
	 YF0IthB1A3pcaKO0bYZzCreEANdQBbjCXnjkAQZNQKMc7Cjnsu7OWpXDWjr56+qOqKTQQIh2E7yS
	 YOIP115ygrQCGpEHci4H7M7Wh1yyNsYHlxtHdfdNmnM76+F5EeZH+/WWZ5gePgqtyhb2gZdAFGW9
	 VYLAieIOQXdndA/Q3AFZzmfEeh7deYGQYj/zyGRL+6oSN5gVStCgNioM7ovPKHjwHktyIR7khFAj
	 KkjLIRwaRiQMsOp1yJByEMwvssT9POGtpGqMAacs7xKgfoLTL9PxaHE+Cctfu9WK4UzWxTOWYdQX
	 Dek2XbXaFjqUWASTZNJwNX2DdTpJ7FRlA50d5580yoJ4pL2jTU/hfhRCBk1tONsLepg7/AKBfzKk
	 1CERX2iPMOyFQj7UdBXq74hWm3hjfveX+2rtyS9g891gLoV1RdX0uux/GJggEv1HyRj4Y+6hwMWa
	 IVtr/yqsM=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: Edward Adam Davis <eadavis@qq.com>
To: herbert@gondor.apana.org.au
Cc: davem@davemloft.net,
	eadavis@qq.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	olivia@selenic.com,
	syzbot+c52ab18308964d248092@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] hwrng: core - fix task hung in hwrng_fillfn
Date: Fri,  1 Dec 2023 19:37:39 +0800
X-OQ-MSGID: <20231201113738.1752175-2-eadavis@qq.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <ZWmt6wrbxN1W+cnv@gondor.apana.org.au>
References: <ZWmt6wrbxN1W+cnv@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 1 Dec 2023 17:56:59 +0800, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
> > index 420f155d251f..7323ddc958ce 100644
> > --- a/drivers/char/hw_random/core.c
> > +++ b/drivers/char/hw_random/core.c
> > @@ -225,17 +225,18 @@ static ssize_t rng_dev_read(struct file *filp, char __user *buf,
> >                        goto out;
> >                }
> >
> > -               if (mutex_lock_interruptible(&reading_mutex)) {
> > -                       err = -ERESTARTSYS;
> > -                       goto out_put;
> > -               }
> >                if (!data_avail) {
> > +                       if (mutex_lock_interruptible(&reading_mutex)) {
> > +                               err = -ERESTARTSYS;
> > +                               goto out_put;
> > +                       }
> >                        bytes_read = rng_get_data(rng, rng_buffer,
> >                                rng_buffer_size(),
> >                                !(filp->f_flags & O_NONBLOCK));
> > +                       mutex_unlock(&reading_mutex);
> >                        if (bytes_read < 0) {
> >                                err = bytes_read;
> > -                               goto out_unlock_reading;
> > +                               goto out_put;
> >                        }
> >                        data_avail = bytes_read;
> >                }
> 
> Does this change anything at all? Please explain why it was holding
> this lock for 143 seconds in the first place.  If it's doing it in
> rng_get_data, then your change has zero effect.
Reduce the scope of critical zone protection.
The original critical zone contains a too large range, especially like 
copy_to_user() should not be included in the critical zone.
> 
> > @@ -501,7 +499,10 @@ static int hwrng_fillfn(void *unused)
> >                rng = get_current_rng();
> >                if (IS_ERR(rng) || !rng)
> >                        break;
> > -               mutex_lock(&reading_mutex);
> > +               if (mutex_lock_interruptible(&reading_mutex)) {
> > +                       put_rng(rng);
> > +                       return -ERESTARTSYS;
> > +               }
> 
> No this is just the symptom.  The real problem is why is the driver
> spending 143 seconds in rng_get_data?
In the second version of the patch, I have removed the fix in hwrng_fillfn().
But for some reason, the V2 patch did not appear in the mailing list.

I think it was due to consuming too much time while executing copy_to_user() 
that resulted in 143s.
So, I narrowed down the scope of the critical area and moved the code 
copy_to_user() out of the critical area.

Edward

