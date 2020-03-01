Return-Path: <SRS0=uwZS=4S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0966EC3F2CD
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Mar 2020 17:53:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C2C182468A
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Mar 2020 17:53:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRZM8P1U"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726146AbgCARx4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Mar 2020 12:53:56 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:36486 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgCARx4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Mar 2020 12:53:56 -0500
Received: by mail-wr1-f65.google.com with SMTP id j16so9618968wrt.3;
        Sun, 01 Mar 2020 09:53:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=lV8YENdLzvicTtDlZeQ6+PGE/+HY5N98/+X62Vk5TCs=;
        b=JRZM8P1UOu4h09GRc15hQR4Lhxdb/yxWJX+PA9h4iMGDvUaic4ujemosKsJtBN3PAX
         PLLGjhTiBj96LFn+jNL1exrW8vh1OLkXKiqFBh7xr+IQDMcurPM9DiB1R2RVsktCqVCm
         ej2Kpm0tZEHNZ57+LlFUkDHFxLppQq2Q/ZCx1B5HhoglFEkxaX7TrmgerI+KPzrmjqNB
         tLcoRdrEqSYHFHOf4bqGyZBsclWCo+XGvWCYmL6QbGMz00GlX628RTlBcebUGKmVLwIv
         4Q+by2Habyts72WApxpsx3EMIm7TpUwvWcLEu+uBjjDwjJy05JrzhiXW6CtD92MuO+Q+
         /7DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=lV8YENdLzvicTtDlZeQ6+PGE/+HY5N98/+X62Vk5TCs=;
        b=IiltpnNfQhLFoxa2zETEV/xXFVSqSzRFrO1INe8yZpzmRwONwQxXK7YNXqYqZxi024
         MHFchIaXIsyZyHDBuZOCtsILa1/bP7JdTv9NUt/ZbY4aapbRotQVptGTeGYKtwhw2ft0
         zsLCpQ+68j3R/ebzGqUIt85jYGCYThLevBD6c67D2P5HOEIu7UYevL0fhcohtSC2pCWl
         gJvJ28CMm0ATp9Ii3CKiTcXBQdhQKmfXfYvvX9vXm/wGS8tl/JJbsQPdfSuPe082wx+R
         6QQP9KjALiADYq99qqyU1s69kckXlYaOSqJrisQimNBDt7svSBpdU0GfQ/g7kF5+S/jQ
         s85g==
X-Gm-Message-State: APjAAAUc64jemZuxD2JtMSKcLNzbRPXDJkMaED/ADIbhLBYn3kMnjR3p
        0/7bygrnL9iDbkj+nkMOZHA=
X-Google-Smtp-Source: APXvYqw7mHZ/1F46q0R8bbrO4uITbQc70UeaZFmqfoWbQ3a0gReO3JftHh0063lOl8zeO0FHgFMYfQ==
X-Received: by 2002:a5d:484f:: with SMTP id n15mr17341866wrs.365.1583085233379;
        Sun, 01 Mar 2020 09:53:53 -0800 (PST)
Received: from Red ([2a01:cb1d:3d5:a100:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id u185sm12075847wmg.6.2020.03.01.09.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 09:53:52 -0800 (PST)
Date:   Sun, 1 Mar 2020 18:53:51 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Will Deacon <will@kernel.org>, tj@kernel.org,
        jiangshanlai@gmail.com, mark.rutland@arm.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Subject: Re: WARNING: at kernel/workqueue.c:1473 __queue_work+0x3b8/0x3d0
Message-ID: <20200301175351.GA11684@Red>
References: <20200217204803.GA13479@Red>
 <20200218163504.y5ofvaejleuf5tbh@ca-dmjordan1.us.oracle.com>
 <20200220090350.GA19858@Red>
 <20200221174223.r3y6tugavp3k5jdl@ca-dmjordan1.us.oracle.com>
 <20200228123311.GE3275@willie-the-truck>
 <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200228153331.uimy62rat2tdxxod@ca-dmjordan1.us.oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 28, 2020 at 10:33:31AM -0500, Daniel Jordan wrote:
> On Fri, Feb 28, 2020 at 12:33:12PM +0000, Will Deacon wrote:
> > On Fri, Feb 21, 2020 at 12:42:23PM -0500, Daniel Jordan wrote:
> > > On Thu, Feb 20, 2020 at 10:03:50AM +0100, Corentin Labbe wrote:
> > > > But I got the same with plain next (like yesterday 5.6.0-rc2-next-20200219 and tomorow 5.6.0-rc2-next-20200220) and master got the same issue.
> > > 
> > > Thanks.  I've been trying to reproduce this on an arm board but it's taking a
> > > while to get it setup since I've never used it for kernel work.
> > > 
> > > Hoping to get it up soon, though someone with a working setup may be in a
> > > better position to help with this.
> > 
> > Any joy with this? It sounded to me like the issue also happens on a
> > mainline kernel. If this is the case, have you managed to bisect it?
> 
> I managed to get recent mainline (rawhide) booting days ago but wasn't able to
> reproduce on a rpi 3b+.
> 
> My plan had been to try debug-by-email next, but then something exploded
> internally and I haven't had time for it yet.  Still intending to help once the
> explosion is contained, provided someone can't get to it sooner.
> 
> thanks,
> Daniel

Hello

I tried to bisect this problem, but the result is:
# bad: [0ecfebd2b52404ae0c54a878c872bb93363ada36] Linux 5.2
git bisect bad 0ecfebd2b52404ae0c54a878c872bb93363ada36
# good: [e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd] Linux 5.1
git bisect good e93c9c99a629c61837d5a7fc2120cd2b6c70dbdd
# bad: [a2d635decbfa9c1e4ae15cb05b68b2559f7f827c] Merge tag 'drm-next-2019-05-09' of git://anongit.freedesktop.org/drm/drm
git bisect bad a2d635decbfa9c1e4ae15cb05b68b2559f7f827c
# bad: [82efe439599439a5e1e225ce5740e6cfb777a7dd] Merge tag 'devicetree-for-5.2' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux
git bisect bad 82efe439599439a5e1e225ce5740e6cfb777a7dd
# bad: [78438ce18f26dbcaa8993bb45d20ffb0cec3bc3e] Merge branch 'stable-fodder' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs
git bisect bad 78438ce18f26dbcaa8993bb45d20ffb0cec3bc3e
# good: [275b103a26e218b3d739e5ab15be6b40303a1428] Merge tag 'edac_for_5.2' of git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp
git bisect good 275b103a26e218b3d739e5ab15be6b40303a1428
# bad: [962d5ecca101e65175a8cdb1b91da8e1b8434d96] Merge tag 'regmap-v5.2' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regmap
git bisect bad 962d5ecca101e65175a8cdb1b91da8e1b8434d96
# good: [181a9096717b8d2128eb1162d07a4f4ee0f9f4b8] crypto: ccree - Make cc_sec_disable static
git bisect good 181a9096717b8d2128eb1162d07a4f4ee0f9f4b8
# good: [5d9e8b3f809f1c12e32fea7061ad2319d2848600] hwmon: (lm25066) Support SAMPLES_FOR_AVG register
git bisect good 5d9e8b3f809f1c12e32fea7061ad2319d2848600
# good: [7aefd944f038c7469571adb37769cb6f3924ecfa] Merge tag 'hwmon-for-v5.2' of git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging
git bisect good 7aefd944f038c7469571adb37769cb6f3924ecfa
# good: [c660a81796d456f0769937dd3ecf4cfd30f0ece6] selftests/kexec: define "require_root_privileges"
git bisect good c660a81796d456f0769937dd3ecf4cfd30f0ece6
# good: [d917fb876f6eaeeea8a2b620d2a266ce26372f4d] selftests: build and run gpio when output directory is the src dir
git bisect good d917fb876f6eaeeea8a2b620d2a266ce26372f4d
# good: [615c4d9a50e25645646c3bafa658aedc22ab7ca9] Merge branch 'regmap-5.2' into regmap-next
git bisect good 615c4d9a50e25645646c3bafa658aedc22ab7ca9
# good: [e59f755ceb6d6f39f90899d2a4e39c3e05837e12] crypto: ccree - use a proper le32 type for le32 val
git bisect good e59f755ceb6d6f39f90899d2a4e39c3e05837e12
# bad: [71ae5fc87c34ecbdca293c2a5c563d6be2576558] Merge tag 'linux-kselftest-5.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
git bisect bad 71ae5fc87c34ecbdca293c2a5c563d6be2576558
# bad: [81ff5d2cba4f86cd850b9ee4a530cd221ee45aa3] Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
git bisect bad 81ff5d2cba4f86cd850b9ee4a530cd221ee45aa3
# first bad commit: [81ff5d2cba4f86cd850b9ee4a530cd221ee45aa3] Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6

The only interesting thing I see in this MR is: "Add fuzz testing to testmgr"

But this wont help.

Regards
