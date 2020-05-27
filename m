Return-Path: <SRS0=h1Lr=7J=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 514D7C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 16:42:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29E7520721
	for <linux-crypto@archiver.kernel.org>; Wed, 27 May 2020 16:42:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KFBFTPaz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgE0QmY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 May 2020 12:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726793AbgE0QmY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 May 2020 12:42:24 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2368BC05BD1E;
        Wed, 27 May 2020 09:42:23 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id 5so1724876pjd.0;
        Wed, 27 May 2020 09:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XocHLjl4KQE4CHPG3EcVffWOwMuyfL2OpIEOiwvn290=;
        b=KFBFTPaz3pEwrQW6KI9k90I66CBEkxGcMewwzCJKlHCAik1KrihheMJUk1xvDFAKJe
         guDv45FCm4veZTMOoYge85g5nWsQ1eiR7wt/hg7p7srl06ObTGrarp+/sn49qlZ33PAp
         XF9NoCJlh6qoTkKY/u9bae9KJ7dGfdV9b0S8VX5slptH93c66jnk/Bde9oGEN1NO1dsS
         /6VHVRtNo9P/9+XDN5Dj3TzwDf6VONYxfPr95VLQJdz71u2yOFfp3/a26abUKClaPlof
         PnKQZ9HoSy5GUYFy54gpfmKxc5tpDED88bQgWhEg4IVhZ0VpfzBvSfzESq3tIyGFLti+
         7BhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XocHLjl4KQE4CHPG3EcVffWOwMuyfL2OpIEOiwvn290=;
        b=qE8SoDuXvKeaBeltrCG+Sp46sNCJKS4VoYr33Ydm0kqqOFYD4tOOk/TaPQ6k5ed7ju
         4uu8zgfQWOsddoDRww/dCmObkzrXTVoUDbaLzpplUkqZcj0wMhmfqQDlIMIGP5LiGoIo
         SrZXR+XFM2G0k5BfecadOGkOCNWsFH4NxbbR0Dh+AnnVyFRbMrbgB35nr6XMxKn4t5XV
         GXweqttF+yLUAB6Soz/oWt4buqZIVgETUrXrKEknfPwe4Fs5nI7tnQi3AjAZpzK6jKNo
         xLVb1rr87kl0HbFC55BpzQlRrQ3+ZncxJwTp1ojCG7yyawzbxMa8KOKqUkvhKz6dbpBr
         R4pg==
X-Gm-Message-State: AOAM530BD7PhSaroA7V7xGwC5YBzH8CfIlNwojuXQucxE2qoinxvniRN
        WJPpOl9B3obzcIYNahDerH8=
X-Google-Smtp-Source: ABdhPJzxbmps8uAE7iJBbTHs0Ipf6Gx3h+MZQmG0wpbg+VJN75Y5wuhCky/NBfrR+RlLzFWjKLGNAw==
X-Received: by 2002:a17:90a:268f:: with SMTP id m15mr6372558pje.190.1590597742622;
        Wed, 27 May 2020 09:42:22 -0700 (PDT)
Received: from ubuntu-s3-xlarge-x86 ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id i21sm2371045pgn.20.2020.05.27.09.42.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 May 2020 09:42:22 -0700 (PDT)
Date:   Wed, 27 May 2020 09:42:19 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, Tim Chen <tim.c.chen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH] x86: crypto: fix building crc32c with clang ias
Message-ID: <20200527164219.GB1073507@ubuntu-s3-xlarge-x86>
References: <20200527141754.1850968-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200527141754.1850968-1-arnd@arndb.de>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 27, 2020 at 04:17:40PM +0200, Arnd Bergmann wrote:
> The clang integrated assembler complains about movzxw:
> 
> arch/x86/crypto/crc32c-pcl-intel-asm_64.S:173:2: error: invalid instruction mnemonic 'movzxw'
> 
> It seems that movzwq is the mnemonic that it expects instead,
> and this is what objdump prints when disassembling the file.
> 
> Fixes: 6a8ce1ef3940 ("crypto: crc32c - Optimize CRC32C calculation with PCLMULQDQ instruction")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

We had an identical patch pending from another contributor, see the
discussion and result in the issue below.

https://github.com/ClangBuiltLinux/linux/issues/1010

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
>  arch/x86/crypto/crc32c-pcl-intel-asm_64.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> index 8501ec4532f4..442599cbe796 100644
> --- a/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> +++ b/arch/x86/crypto/crc32c-pcl-intel-asm_64.S
> @@ -170,7 +170,7 @@ continue_block:
>  
>  	## branch into array
>  	lea	jump_table(%rip), %bufp
> -	movzxw  (%bufp, %rax, 2), len
> +	movzwq  (%bufp, %rax, 2), len
>  	lea	crc_array(%rip), %bufp
>  	lea     (%bufp, len, 1), %bufp
>  	JMP_NOSPEC bufp
> -- 
> 2.26.2
> 
