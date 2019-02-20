Return-Path: <SRS0=bqmp=Q3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F14C8C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 16:33:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB0FB2147C
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Feb 2019 16:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550680398;
	bh=bG49K4a5WQSeLLab12gXAcvZcyQimj7bABH2fQhOVUU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eiGaDLYZzhY3cOKVR188KFtY5hiA5Ou/cuR/o1hDtr0W/O6VQeHqWk53X2v5k4M0q
	 sdCvl63mn66yfC8Zie4AbqDGJ/oT3v3JndD4++PWVE2nFBswoid4NPzeh7rQ6P3zUA
	 3opEoOcyI0WNgulYU9EAny9OdHmNei1KUWmnd1ko=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfBTQdR (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Feb 2019 11:33:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:57540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbfBTQdR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Feb 2019 11:33:17 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 115F02147A;
        Wed, 20 Feb 2019 16:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550680396;
        bh=bG49K4a5WQSeLLab12gXAcvZcyQimj7bABH2fQhOVUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NrgR2kA+7Cay8rMoR1K9ApdY/O58hFaZ1Tc/2OUwI20jAYTjK0MZ6mP50bshPnieG
         Xd7SZknehtbn5FRf5pj4Q9IgY8S+XPGaVT2GJUTX+VfVx5gLxtauHyZy0H9Wnr8MzO
         Lq/YiclBrZmdBlu4+uz2HZCeVJGXdDund8zymaRc=
Date:   Wed, 20 Feb 2019 17:33:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sumit Garg <sumit.garg@linaro.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Colin Ian King <colin.king@canonical.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH -next] hwrng: make symbol 'optee_rng_id_table' static
Message-ID: <20190220163313.GA3454@kroah.com>
References: <20190220093458.159208-1-weiyongjun1@huawei.com>
 <CAFA6WYODEymSPh6gQjUL3wRmoPy=zoMv-Z1Q1TbKtWFH=UUgMw@mail.gmail.com>
 <CAKv+Gu9yWEVvvoh8KOX1waZUrM1hy+P99Rxh3U2nPYE_sgyJzQ@mail.gmail.com>
 <8a3ff7ae-9257-82f1-70e2-91cc77aa7377@canonical.com>
 <CAFA6WYMU0GwYaOgyoCAKSUat0kHOGRnV6UWG0Co0EfHrpO4ryA@mail.gmail.com>
 <CAK8P3a3FMa9tpw4rj+8Aue2EYxxKSD4nxdwRFrzac_87Kzio5g@mail.gmail.com>
 <CAFA6WYNCxGTqw6LKUPK-ceWD1NbAhJQmzrH5fwOVRP5f2Auz2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFA6WYNCxGTqw6LKUPK-ceWD1NbAhJQmzrH5fwOVRP5f2Auz2Q@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 20, 2019 at 09:55:50PM +0530, Sumit Garg wrote:
> Hi Arnd,
> 
> On Wed, 20 Feb 2019 at 21:04, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > On Wed, Feb 20, 2019 at 12:17 PM Sumit Garg <sumit.garg@linaro.org> wrote:
> > >
> > > On Wed, 20 Feb 2019 at 16:19, Colin Ian King <colin.king@canonical.com> wrote:
> > > >
> > > > On 20/02/2019 10:37, Ard Biesheuvel wrote:
> > > > > On Wed, 20 Feb 2019 at 11:34, Sumit Garg <sumit.garg@linaro.org> wrote:
> > > > >>
> > > > >> On Wed, 20 Feb 2019 at 14:51, Wei Yongjun <weiyongjun1@huawei.com> wrote:
> > > > >>>
> > > > >>> Fixes the following sparse warning:
> > > > >>>
> > > > >>> drivers/char/hw_random/optee-rng.c:265:35: warning:
> > > > >>>  symbol 'optee_rng_id_table' was not declared. Should it be static?
> > > > >>>
> > > > >>
> > > > >> I haven't observed this warning during my normal Linux build using
> > > > >> gcc. Is there any specific configuration you are using?
> > > > >>
> > > > >
> > > > > This is a sparse warning, not GCC. You need to install it separately
> > > > > and build with C=1 (iirc)
> > > > >
> > >
> > > TBH, I wasn't aware about this sparse tool. I did install sparse and
> > > build with C=1 option. But I could only get following such
> > > errors/warnings for drivers/char/hw_random/optee-rng.c:
> > >
> > > ./arch/arm64/include/asm/lse.h:18:37: warning: Unknown escape 'l'
> > > ./arch/arm64/include/asm/alternative.h:213:28: warning: Unknown escape 'o'
> > > ./include/linux/compiler.h:194:8: error: attribute '__gnu_inline__':
> > > unknown attribute
> > >
> > > But not the one mentioned in this patch.
> >
> > Not sure what went wrong, I see the same warning as the others.
> > Maybe you have an outdated version of sparse that runs into unrelated
> > issues?
> >
> 
> $ apt list sparse
> Listing... Done
> sparse/xenial,now 0.5.0-1build1 amd64 [installed]

Ick, really obsolete, please use the sparse version on kernel.org for
kernel stuff:
	git://git.kernel.org/pub/scm/devel/sparse/sparse.git

Loads of things have been fixed and resolved from 0.5.0 which is very
old.

thanks,

greg k-h
