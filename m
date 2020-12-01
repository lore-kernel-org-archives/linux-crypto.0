Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F6B6C83012
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 13:54:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA3C820770
	for <linux-crypto@archiver.kernel.org>; Tue,  1 Dec 2020 13:54:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qPXC0hQO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391417AbgLANxo (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 1 Dec 2020 08:53:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391452AbgLANxm (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 1 Dec 2020 08:53:42 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43382C0613CF;
        Tue,  1 Dec 2020 05:52:56 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id i2so2746734wrs.4;
        Tue, 01 Dec 2020 05:52:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=61ZF5C7WOPaSSyFKTA3Jd4EkoVpR2O0GmABB6DAtO/M=;
        b=qPXC0hQO8OpdRZI104m8FraSMCwSpn+Et3stR+21jZOV9O3VXrd6HW4YZYKFF3+Ks+
         aierhs90V6L+OmvFxDeym42bp7bQTW/q+RefaHc+QA7BBbjrhFrYonYBaR5QpVXOVjyW
         kjJCIP9TJWGtxpmXssFodLlrYfQy6v2Yfb4DTwUThhf0IRP8S64JlEnO6z+9heefTbHF
         N3y3NiLQPrsPP94v3GukxSOAasSoxPx8crAxnkcliVQwOpN7rwU3TYnVoH4S3RSWGf19
         tFfvN5e7+eiD4uruVlKQ+mMviP2h5S+9MGgkYSLnJ0U71Ct52xWVFl1rsAFtr3tE0uq3
         xqXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=61ZF5C7WOPaSSyFKTA3Jd4EkoVpR2O0GmABB6DAtO/M=;
        b=M8QvL7h6xv705aiJqr4h2ucEgoPY3SuPlI10nSbF5rBOIzKgzNQkXubPR0y62rdeDj
         lZ/nmnlBjYnzYLJHX9968Bv9HLJFN9CQWKRdQ55mvR+NdFWfyVrzFsHcRHidSog8QWsV
         LMq1Ak3yAtUOmRf7wgs5lSaOdA3o8X1ZdNNKGq5hlgToF1RDvOzbIqi++vEv0xsIz0ba
         2qk1Xl/osZJ9qpnH1xZhg1Bty3vPjGuBJC4ngyJ8SeFySLdkvD0yoDe11FJVuFS5b5Fi
         P/C3MBVt20BI/QBnikySdB+sttgadgQtoM66WSKOFW6kZTSN3Cw3rdLd/oBYhk5cAoQd
         EKMw==
X-Gm-Message-State: AOAM531r5fYqclILZzZv5jXrL9253tsLw0mtujylU3cfu5UmMVgHtbP5
        RRwz0V0Q8Rb/LMZEy6ip/tbs786ctq4=
X-Google-Smtp-Source: ABdhPJzNqXDB+VXwYa+0PZjxxL8p3TimpJzCucLOvKCHK+ncKgnQg/CctWHRNkn4ceRMCJpSdRnwRA==
X-Received: by 2002:adf:f602:: with SMTP id t2mr4138518wrp.40.1606830775033;
        Tue, 01 Dec 2020 05:52:55 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id l8sm3567987wro.46.2020.12.01.05.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 05:52:54 -0800 (PST)
Date:   Tue, 1 Dec 2020 14:52:52 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: crypto: sun4i-ss: error with kmap
Message-ID: <20201201135252.GA9584@Red>
References: <20201201130102.GA23461@Red>
 <87ft4phcyx.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ft4phcyx.fsf@nanos.tec.linutronix.de>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Dec 01, 2020 at 02:28:54PM +0100, Thomas Gleixner wrote:
> On Tue, Dec 01 2020 at 14:01, Corentin Labbe wrote:
> > +[  213.050152] ------------[ cut here ]------------
> > +[  213.050207] WARNING: CPU: 0 PID: 18430 at mm/highmem.c:581 kunmap_local_indexed+0x194/0x1d4
> > +[  213.050214] Modules linked in: sm4_generic authenc vmac xcbc hmac streebog_generic sm3_generic sha3_generic crct10dif_generic crct10dif_common seed rmd320 rmd256 rmd160 rmd128 cts lzo lzo_compress salsa20_generic camellia_generic fcrypt pcbc tgr192 anubis wp512 khazad tea michael_mic arc4 cast6_generic cast5_generic cast_common deflate zlib_deflate sha512_generic cfb ofb serpent_generic lrw twofish_generic twofish_common blowfish_generic blowfish_common md4
> > +[  213.050410] CPU: 0 PID: 18430 Comm: cryptsetup Not tainted 5.10.0-rc5-next-20201130-00059-gf7ecf0611042-dirty #242
> > +[  213.050416] Hardware name: Allwinner sun7i (A20) Family
> > +[  213.050448] [<c010d730>] (unwind_backtrace) from [<c010a218>] (show_stack+0x10/0x14)
> > +[  213.050465] [<c010a218>] (show_stack) from [<c08bbdcc>] (dump_stack+0x98/0xac)
> > +[  213.050479] [<c08bbdcc>] (dump_stack) from [<c08b93ac>] (__warn+0xc0/0xd8)
> > +[  213.050491] [<c08b93ac>] (__warn) from [<c08b9428>] (warn_slowpath_fmt+0x64/0xc0)
> > +[  213.050505] [<c08b9428>] (warn_slowpath_fmt) from [<c02018b4>] (kunmap_local_indexed+0x194/0x1d4)
> > +[  213.050525] [<c02018b4>] (kunmap_local_indexed) from [<c03e0390>] (sg_miter_stop+0xb4/0x164)
> > +[  213.050541] [<c03e0390>] (sg_miter_stop) from [<c03e082c>] (sg_miter_next+0xc/0xe4)
> > +[  213.050560] [<c03e082c>] (sg_miter_next) from [<c06b2d04>] (sun4i_ss_opti_poll+0x278/0x40c)
> > +[  213.050575] [<c06b2d04>] (sun4i_ss_opti_poll) from [<c06b338c>] (sun4i_ss_cipher_poll+0x4f4/0x5e4)
> > +[  213.050590] [<c06b338c>] (sun4i_ss_cipher_poll) from [<c03991d4>] (crypto_skcipher_encrypt+0x38/0x5c)
> > +[  213.050604] [<c03991d4>] (crypto_skcipher_encrypt) from [<c03aa980>] (xts_encrypt+0x8c/0xd4)
> > +[  213.050617] [<c03aa980>] (xts_encrypt) from [<c03991d4>] (crypto_skcipher_encrypt+0x38/0x5c)
> > +[  213.050631] [<c03991d4>] (crypto_skcipher_encrypt) from [<c03b3d94>] (skcipher_recvmsg+0x364/0x43c)
> > +[  213.050646] [<c03b3d94>] (skcipher_recvmsg) from [<c0719650>] (sock_read_iter+0xa8/0xf8)
> > +[  213.050663] [<c0719650>] (sock_read_iter) from [<c0239e98>] (vfs_read+0x2b8/0x2d8)
> > +[  213.050676] [<c0239e98>] (vfs_read) from [<c023a398>] (ksys_read+0xb0/0xe4)
> > +[  213.050688] [<c023a398>] (ksys_read) from [<c0100060>] (ret_fast_syscall+0x0/0x58)
> > +[  213.050695] Exception stack(0xc4d13fa8 to 0xc4d13ff0)
> > +[  213.050707] 3fa0:                   00000006 b6f084d0 00000006 b47ff000 00010000 00000000
> > +[  213.050718] 3fc0: 00000006 b6f084d0 00010000 00000003 00000030 beb6e9bc 00000010 beb6e9fc
> > +[  213.050727] 3fe0: b6e3609c beb6e958 b6cc8504 b6cc851c
> > +[  213.050735] ---[ end trace 915906e6b0e8a55d ]---
> 
> Hmm. No registers there. Can you apply the patch below so we can see the
> address?
> 
> Thanks,
> 
>         tglx
> ---
> diff --git a/mm/highmem.c b/mm/highmem.c
> index b49364a306b8..240fc6e5bfb4 100644
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -571,8 +571,10 @@ void kunmap_local_indexed(void *vaddr)
>  		 * PAGE_OFFSET. Warn for all other addresses which are in
>  		 * the user space part of the virtual address space.
>  		 */
> -		if (!kmap_high_unmap_local(addr))
> +		if (!kmap_high_unmap_local(addr)) {
> +			pr_err("kunmap_local: vaddr %lx\n", (unsigned long) vaddr);
>  			WARN_ON_ONCE(addr < PAGE_OFFSET);
> +		}
>  		return;
>  	}
>  

The patch made the board too busy logging and fail to boot until the test.

Regards
