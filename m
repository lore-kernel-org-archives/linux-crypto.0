Return-Path: <SRS0=AsAY=B5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 780BFC433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Aug 2020 20:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A517207FF
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Aug 2020 20:19:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="UkTgMmGQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgHSUTs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Aug 2020 16:19:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726868AbgHSUTn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Aug 2020 16:19:43 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A4E7C061757
        for <linux-crypto@vger.kernel.org>; Wed, 19 Aug 2020 13:19:42 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id kr4so1619411pjb.2
        for <linux-crypto@vger.kernel.org>; Wed, 19 Aug 2020 13:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XLirLW1tFX6aq5/fvtexJPQ7DxoWfhmW8pe0fQrP5bg=;
        b=UkTgMmGQ79dY+FIyJM67YTw4C5AJFoPakBdS0s4l7Vb+KImQuggjNUOWIcHAZMTEXi
         j63H5NW4ORY2oOr/9/DF+C7Lo7mnZ/70ZGwGoIyNykNoSCkFFQ3QTGD00w/1h8Bxcqor
         Bvpu+KXX7yjNoN7flcGlp/6bPTWgE4l1L7Ge8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XLirLW1tFX6aq5/fvtexJPQ7DxoWfhmW8pe0fQrP5bg=;
        b=K+/VolVAGP41bMsaIwGVDNGcOxIWrT6R1WCBu1sqcVIcIKt6XR8WRsEy6cbSzB8xkn
         jE3bE7CTXcRStVK+GePXCMvzRqqDjcSEhyzfVx1WHXQo9q2rzJEtVDAnoQXKtvbw8rWh
         qA9gZFGg6BdAepSlNglnjxWyOVXGerzg3QIixICNN5b/kZEZhuPYnmbDYBPhol5ZMQ31
         UwkfLKVZ0wRAx8C+/+k1Qsty3Ucewxh+/As2InBvVGAjn8481s6drip+cqW7ZW+s//3J
         TkGbBS6EPgYIuWqHCOHNHbtpZO65EZOmvPsak6bLKtg1mxqkpg5KTLxffPBssMTYmiyf
         FTsg==
X-Gm-Message-State: AOAM530nyAfzVJKSJfjLKL/PYS/4tzUCK11RvFdlBswZLvkkdin8i97b
        j9i4Tmcv5g+qbFl1x5avv575eg==
X-Google-Smtp-Source: ABdhPJwNhbZZClRgRNsAf3niT4djncsIA3qQkF5kXM/h8F9YxuXx23DwA+vIWlsvo+bkArvcTJeSqw==
X-Received: by 2002:a17:90a:fe89:: with SMTP id co9mr2912891pjb.30.1597868381863;
        Wed, 19 Aug 2020 13:19:41 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id l24sm69316pff.20.2020.08.19.13.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 13:19:40 -0700 (PDT)
Date:   Wed, 19 Aug 2020 13:19:39 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joan Bruguera <joanbrugueram@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     haren@us.ibm.com, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] Add missing bound checks for software 842 decompressor
Message-ID: <202008191311.A4E1B54@keescook>
References: <20200605154416.5022-1-joanbrugueram@gmail.com>
 <6b69d99f-515f-b53c-b1c1-d525788779e3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b69d99f-515f-b53c-b1c1-d525788779e3@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Aug 16, 2020 at 02:33:41AM +0200, Joan Bruguera wrote:
> Any feedback?

Hi!

I just happened to see this email. I think this should likely be
directed to the crypto (which also handled compress/decompress APIs)
list and the original author...

Additional notes below...

> - Joan
> 
> On 05.06.20 17:44, Joan Bruguera wrote:
> > The software 842 decompressor receives, through the initial value of the
> > 'olen' parameter, the capacity of the buffer pointed to by 'out'. If this
> > capacity is insufficient to decode the compressed bitstream, -ENOSPC
> > should be returned.
> > 
> > However, the bounds checks are missing for index references (for those
> > ops. where decomp_ops includes a I2, I4 or I8 subop.), and also for
> > OP_SHORT_DATA. Due to this, sw842_decompress can write past the capacity
> > of the 'out' buffer.

Eek. :(

> > 
> > The case for index references can be triggered by compressing data that
> > follows a 16-byte periodic pattern (excluding special cases which are
> > better encoded by OP_ZEROS) and passing a 'olen' somewhat smaller than the
> > original length.
> > The case for OP_SHORT_DATA can be triggered by compressing an amount of
> > data that is not a multiple of 8, and then a slightly smaller 'olen' that
> > can't fit those last <8 bytes.
> > 
> > Following is a small test module to demonstrate the issue.
> > 
> > -
> > 
> > #include <linux/module.h>
> > #include <linux/kernel.h>
> > #include <linux/sw842.h>
> > 
> > static unsigned char workspace[1000000] = { 0 }; // Hacky
> > 
> > static void test_bound(const char *name, unsigned ibound, unsigned dbound)
> > {
> > 	uint8_t in[ibound], out[ibound * 4], decomp[ibound /* Overallocated */];
> > 	unsigned clen = ibound * 4, dlen = dbound, i;
> > 	int ret;
> > 
> > 	for (i = 0; i < ibound; i ++)
> > 		in[i] = i % 16; // 0, 1, 2, ..., 14, 15, 0, 1, 2, ...
> > 	for (i = dbound; i < ibound; i++)
> > 		decomp[i] = 0xFF; // Place guard bytes
> > 
> > 	ret = sw842_compress(in, ibound, out, &clen, workspace);
> > 	BUG_ON(ret != 0);
> > 
> > 	ret = sw842_decompress(out, clen, decomp, &dlen);
> > 	if (ret != -ENOSPC) {
> > 		printk(KERN_ERR "%s: Expected ENOSPC to be returned\n", name);
> > 	}
> > 	for (i = dbound; i < ibound; i++) {
> > 		if (decomp[i] != 0xFF) {
> > 			printk(KERN_ERR "%s: Guard overwritten\n", name);
> > 			break;
> > 		}
> > 	}
> > }
> > 
> > int init_module(void)
> > {
> > 	test_bound("Index reference test", 256, 64);
> > 	test_bound("Short data test", 12, 8);
> > 	return -ECANCELED; // Do not leave this test module hanging around
> > }
> > 
> > void cleanup_module(void)
> > {
> > }
> > 
> > MODULE_LICENSE("GPL");
> > MODULE_SOFTDEP("pre: 842");

Can this test be added to the kernel source directly? It'd be nice to
add such a regression test.

> > 
> > Signed-off-by: Joan Bruguera <joanbrugueram@gmail.com>
> > ---
> >   lib/842/842_decompress.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/lib/842/842_decompress.c b/lib/842/842_decompress.c
> > index 582085ef8b4..c29fbfc9d08 100644
> > --- a/lib/842/842_decompress.c
> > +++ b/lib/842/842_decompress.c
> > @@ -202,6 +202,9 @@ static int __do_index(struct sw842_param *p, u8 size, u8 bits, u64 fsize)
> >   			 (unsigned long)total,
> >   			 (unsigned long)beN_to_cpu(&p->ostart[offset], size));
> > +	if (size > p->olen)
> > +		return -ENOSPC;
> > +
> >   	memcpy(p->out, &p->ostart[offset], size);
> >   	p->out += size;
> >   	p->olen -= size;
> > @@ -345,6 +348,9 @@ int sw842_decompress(const u8 *in, unsigned int ilen,
> >   			if (!bytes || bytes > SHORT_DATA_BITS_MAX)
> >   				return -EINVAL;
> > +			if (bytes > p.olen)
> > +				return -ENOSPC;
> > +
> >   			while (bytes-- > 0) {
> >   				ret = next_bits(&p, &tmp, 8);
> >   				if (ret)
> > 

Reviewed-by: Kees Cook <keescook@chromium.org>


-- 
Kees Cook
