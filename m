Return-Path: <SRS0=FtFJ=5D=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2956C10DCE
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Mar 2020 06:40:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA4C620768
	for <linux-crypto@archiver.kernel.org>; Wed, 18 Mar 2020 06:40:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=axtens.net header.i=@axtens.net header.b="FtR2PsJj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgCRGkw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 18 Mar 2020 02:40:52 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45560 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbgCRGkw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 18 Mar 2020 02:40:52 -0400
Received: by mail-pg1-f193.google.com with SMTP id m15so13111862pgv.12
        for <linux-crypto@vger.kernel.org>; Tue, 17 Mar 2020 23:40:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=XzGu2D0qbUiQXlYIBSsYZEbEbHXflKv2iEThfbgwGOA=;
        b=FtR2PsJjhjhKf5THRO1zaSBNSWnNScL3wmfKecLJuGLphjWSBVrpyhEaqdSCNdSvUQ
         9FrvdstZbxCKwoBww4uyXL3VL1qbVUFSpIw7QtI0+oTebzcUk4pXZyjSFF5ZBCT1lOcw
         Qa5HTtUFLY9yhYArROexRhc0SxHUYghz9Km4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=XzGu2D0qbUiQXlYIBSsYZEbEbHXflKv2iEThfbgwGOA=;
        b=Lli67ii7iakD8A5e6wwAifpqWrGAqcmyqelveIwL43TOnnVS6NC7Y6XU7LY8MJzIkf
         uu28sFBiv2pAxuS3ZPPj/ZqPn6jyOS1qU5SiYumJPwi1b5o/ilG0Gu0GfTqJrfIuhJXj
         Ekc04Oa+eaf03TJWuOCKKHZ0Gl6cBhFnYXXAxZk058EFbYgr6WNJ1auR05AbY1h3hhJf
         oeIr0f9Fxg3Wpcl3iBeeGOK5ZBfUbEXMGAM45Jdci2mf+0Gt5gE+1Az1CLpfaJEu6OKr
         JEtSYyH4redFy//7wcSlZa6QC9TaAdpzgksynqG/t3gGPzkymIjLruYlZBhVSQgjFjz6
         wRdQ==
X-Gm-Message-State: ANhLgQ3RtRxtrpCG7q+7i5ibuC53LXRnPpwQ4ISD3RohDP/yhJZEYpoK
        YUd3/HCxWA1FOZapCTuQcp/mj1+7gU4=
X-Google-Smtp-Source: ADFU+vuuLgtMuWos5RSXth1TDFodBLLeGr0ujcN7Kxgun0iHFMriORUyvEX61Ty5qRi6xy2iWUvIrQ==
X-Received: by 2002:aa7:95a1:: with SMTP id a1mr2834620pfk.279.1584513650717;
        Tue, 17 Mar 2020 23:40:50 -0700 (PDT)
Received: from localhost (2001-44b8-111e-5c00-11e1-e7cb-3c10-05d6.static.ipv6.internode.on.net. [2001:44b8:111e:5c00:11e1:e7cb:3c10:5d6])
        by smtp.gmail.com with ESMTPSA id t8sm1244142pjy.11.2020.03.17.23.40.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2020 23:40:49 -0700 (PDT)
From:   Daniel Axtens <dja@axtens.net>
To:     Raphael Moreira Zinsly <rzinsly@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, linux-crypto@vger.kernel.org
Cc:     Raphael Moreira Zinsly <rzinsly@linux.ibm.com>,
        haren@linux.ibm.com, herbert@gondor.apana.org.au, abali@us.ibm.com
Subject: Re: [PATCH 5/5] selftests/powerpc: Add README for GZIP engine tests
In-Reply-To: <20200316180714.18631-6-rzinsly@linux.ibm.com>
References: <20200316180714.18631-1-rzinsly@linux.ibm.com> <20200316180714.18631-6-rzinsly@linux.ibm.com>
Date:   Wed, 18 Mar 2020 17:40:46 +1100
Message-ID: <874kumnp1t.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

This is a good readme, the instructions for compiling and testing work.

Reviewed-by: Daniel Axtens <dja@axtens.net>

Regards,
Daniel

Raphael Moreira Zinsly <rzinsly@linux.ibm.com> writes:

> Include a README file with the instructions to use the
> testcases at selftests/powerpc/nx-gzip.
>
> Signed-off-by: Bulent Abali <abali@us.ibm.com>
> Signed-off-by: Raphael Moreira Zinsly <rzinsly@linux.ibm.com>
> ---
>  .../powerpc/nx-gzip/99-nx-gzip.rules          |  1 +
>  .../testing/selftests/powerpc/nx-gzip/README  | 44 +++++++++++++++++++
>  2 files changed, 45 insertions(+)
>  create mode 100644 tools/testing/selftests/powerpc/nx-gzip/99-nx-gzip.rules
>  create mode 100644 tools/testing/selftests/powerpc/nx-gzip/README
>
> diff --git a/tools/testing/selftests/powerpc/nx-gzip/99-nx-gzip.rules b/tools/testing/selftests/powerpc/nx-gzip/99-nx-gzip.rules
> new file mode 100644
> index 000000000000..5a7118495cb3
> --- /dev/null
> +++ b/tools/testing/selftests/powerpc/nx-gzip/99-nx-gzip.rules
> @@ -0,0 +1 @@
> +SUBSYSTEM=="nxgzip", KERNEL=="nx-gzip", MODE="0666"
> diff --git a/tools/testing/selftests/powerpc/nx-gzip/README b/tools/testing/selftests/powerpc/nx-gzip/README
> new file mode 100644
> index 000000000000..ff0c817a65c5
> --- /dev/null
> +++ b/tools/testing/selftests/powerpc/nx-gzip/README
> @@ -0,0 +1,44 @@
> +Test the nx-gzip function:
> +=========================
> +
> +Verify that following device exists:
> +  /dev/crypto/nx-gzip
> +If you get a permission error run as sudo or set the device permissions:
> +   sudo chmod go+rw /dev/crypto/nx-gzip
> +However, chmod may not survive across boots. You may create a udev file such
> +as:
> +   /etc/udev/rules.d/99-nx-gzip.rules
> +
> +
> +Then make and run:
> +$ make
> +gcc -O3 -I./inc -o gzfht_test gzfht_test.c gzip_vas.c
> +gcc -O3 -I./inc -o gunz_test gunz_test.c gzip_vas.c
> +
> +
> +Compress any file using Fixed Huffman mode. Output will have a .nx.gz suffix:
> +$ ./gzfht_test gzip_vas.c
> +file gzip_vas.c read, 5276 bytes
> +compressed 5276 to 2564 bytes total, crc32 checksum = b937a37d
> +
> +
> +Uncompress the previous output. Output will have a .nx.gunzip suffix:
> +$ ./gunz_test gzip_vas.c.nx.gz
> +gzHeader FLG 0
> +00 00 00 00 04 03
> +gzHeader MTIME, XFL, OS ignored
> +computed checksum b937a37d isize 0000149c
> +stored   checksum b937a37d isize 0000149c
> +decomp is complete: fclose
> +
> +
> +Compare two files:
> +$ sha1sum gzip_vas.c.nx.gz.nx.gunzip gzip_vas.c
> +f041cd8581e8d920f79f6ce7f65411be5d026c2a  gzip_vas.c.nx.gz.nx.gunzip
> +f041cd8581e8d920f79f6ce7f65411be5d026c2a  gzip_vas.c
> +
> +
> +Note that the code here are intended for testing the nx-gzip hardware function.
> +They are not intended for demonstrating performance or compression ratio.
> +For more information and source code consider using:
> +https://github.com/libnxz/power-gzip
> -- 
> 2.21.0
