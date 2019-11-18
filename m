Return-Path: <SRS0=iOo2=ZK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61216C432C0
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 10:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3939620726
	for <linux-crypto@archiver.kernel.org>; Mon, 18 Nov 2019 10:04:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FELuli8c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfKRKEF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Nov 2019 05:04:05 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44349 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfKRKEF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Nov 2019 05:04:05 -0500
Received: by mail-wr1-f67.google.com with SMTP id f2so18655418wrs.11;
        Mon, 18 Nov 2019 02:04:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WdDz0mrFyY802jpioK8Tj777aw83BXkZyt25Ka99dqg=;
        b=FELuli8caTlGpXUoSyRgcCAWWob89CrR4hGGCPib2d3FmDVnaOsWsiZgD2FD4Zc+Bh
         /huKwCvvQs98zfTz0GyIJViCy/96jQEKQUMoL11foqDw4DcIgu2illbmb3bNmy11SReV
         RLQipDf36JePZTzZIiI3DZ0tMO77eNJAjEexXHjFsgYLntS+5LG02mn0TPrCZi6XwId3
         CJt1e5d3Fh3nyn1Xp1OSNpw8hSznLHKfuCqF84dNFWbv5LDI+OIledAIZPKb86kQ+o08
         ac9bnlyDFv8Mnmx7RYnmPrm7qasBVCpvTrhTiOLYggAuEiV8DsQCY+kY9g6Kco9FSgTS
         3caA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WdDz0mrFyY802jpioK8Tj777aw83BXkZyt25Ka99dqg=;
        b=bYBmvYJHXYQ173qmp0LDyZifQbR8haMTkiULFbbvvduiAVC9xtXzpuTxf8L1XUdd/S
         seot3CDIaTPb4g2B8Y4ENBqfQXvmVijJ15YvLLXvOFoAUhRWBgfSJyjNubzh1jHuxbSi
         JzfgCXyEGfkvp5AZvXSunzxUnob4wSWpEdbSYurlpzxCWUs4eEh3Xe83oRBLV7hutmcA
         xsBmkms9UYOV44AXIbiiEl6ubSUPO2zsm1RpTR02ruYa5/uCYKq3bI+WUFS+sBbAnHK1
         /J6R9FZu2pMifQ1NvLhxIW/wunb0uCG3xbL5pWeOyhfhOMl9RVeenr7aSnwLNoZ8jV7g
         vAEQ==
X-Gm-Message-State: APjAAAVkotGU3L7o+28fqteZpbT65NUxv2T3HghoDGKYpDb/T25ewQdi
        DQlbdiMXko4lmxmmuzOBriE=
X-Google-Smtp-Source: APXvYqy0f+ZAHlRAAURCDBWqtJqMVGtzVIbkiJxxCnaLErOz29EUQCGlTC2IwHAKeqzKn48krWM9ng==
X-Received: by 2002:a5d:4986:: with SMTP id r6mr28761870wrq.307.1574071441548;
        Mon, 18 Nov 2019 02:04:01 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id j14sm22082676wrp.16.2019.11.18.02.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 02:04:00 -0800 (PST)
Date:   Mon, 18 Nov 2019 11:03:58 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, davem@davemloft.net,
        herbert@gondor.apana.org.au, mripard@kernel.org, wens@csie.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/2] crypto: sun4i-ss: remove dependency on not 64BIT
Message-ID: <20191118100358.GA4567@Red>
References: <20191114104907.10645-2-clabbe.montjoie@gmail.com>
 <201911181510.4s0BW0Qc%lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201911181510.4s0BW0Qc%lkp@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 18, 2019 at 03:12:14PM +0800, kbuild test robot wrote:
> Hi Corentin,
> 
> I love your patch! Perhaps something to improve:
> 
> [auto build test WARNING on cryptodev/master]
> [also build test WARNING on next-20191115]
> [cannot apply to v5.4-rc8]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Corentin-Labbe/crypto-sun4i-ss-Fix-64-bit-size_t-warnings-on-sun4i-ss-hash-c/20191114-211327
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master
> config: arm64-allyesconfig (attached as .config)
> compiler: aarch64-linux-gcc (GCC) 7.4.0
> reproduce:
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         GCC_VERSION=7.4.0 make.cross ARCH=arm64 
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 

Hello

Thoses warning are handle by the "[PATCH] crypto: sun4i-ss - Fix 64-bit size_t warnings" from Herbert.

Regards
