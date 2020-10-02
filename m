Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86F43C4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 15:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A57320719
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 15:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601651537;
	bh=dfS3hUtPj+62nOaD8ZISFxx2RrbIO5cTDVZpKj0K2sY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=g0ycCBo7Cxj1yuZiI4uii1nu7fEJuLvrylPSDCCJy2KJtXBznL90czeisMjFuDoJC
	 FyUcW0o+Dh13VkhTlmlTkOsxHtMNOVqRSd0z1y9AQGohzG0rvk8Rkw21qYnKCkuAO4
	 d3HfVsAP4R1vD/QKM0a04z8CJBqb7TazNaJ/TGBk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387893AbgJBPMQ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 11:12:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:56034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBPMQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 11:12:16 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D7EC206CA;
        Fri,  2 Oct 2020 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601651534;
        bh=dfS3hUtPj+62nOaD8ZISFxx2RrbIO5cTDVZpKj0K2sY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bvS8ENUJvIS83nogxkOB2809owzEzxCuRopX/nbXImTp4wvwoRvmmQ24dXyR92t43
         VMZCulyYO0mfUK8fgu5WtU2MnNsVW9vIE6+22jdsZWlriACuIdHj6bW279qr4HfsBJ
         tt4uFH4LdCU1lUw5pSlUZBg3pbtA9XdtudYLXVo8=
Date:   Fri, 2 Oct 2020 17:13:00 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Van Leeuwen, Pascal" <pvanleeuwen@rambus.com>
Cc:     Torsten Duwe <duwe@lst.de>, "Theodore Y. Ts'o" <tytso@mit.edu>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Willy Tarreau <w@1wt.eu>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
        Petr Tesarik <ptesarik@suse.cz>
Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST
 SP800-90B compliance
Message-ID: <20201002151300.GC5212@kroah.com>
References: <20200921075857.4424-1-nstange@suse.de>
 <20201002123836.GA14807@lst.de>
 <CY4PR0401MB365298FA8C0C53EAF2D66705C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
 <20201002140428.GC3475053@kroah.com>
 <CY4PR0401MB365240353B6AB3B2045C9F89C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CY4PR0401MB365240353B6AB3B2045C9F89C3310@CY4PR0401MB3652.namprd04.prod.outlook.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 02, 2020 at 02:34:44PM +0000, Van Leeuwen, Pascal wrote:
> 
> 
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Friday, October 2, 2020 4:04 PM
> > To: Van Leeuwen, Pascal <pvanleeuwen@rambus.com>
> > Cc: Torsten Duwe <duwe@lst.de>; Theodore Y. Ts'o <tytso@mit.edu>; linux-crypto@vger.kernel.org; Nicolai Stange
> > <nstange@suse.de>; LKML <linux-kernel@vger.kernel.org>; Arnd Bergmann <arnd@arndb.de>; Eric W. Biederman
> > <ebiederm@xmission.com>; Alexander E. Patrakov <patrakov@gmail.com>; Ahmed S. Darwish <darwish.07@gmail.com>; Willy
> > Tarreau <w@1wt.eu>; Matthew Garrett <mjg59@srcf.ucam.org>; Vito Caputo <vcaputo@pengaru.com>; Andreas Dilger
> > <adilger.kernel@dilger.ca>; Jan Kara <jack@suse.cz>; Ray Strode <rstrode@redhat.com>; William Jon McCann <mccann@jhu.edu>;
> > zhangjs <zachary@baishancloud.com>; Andy Lutomirski <luto@kernel.org>; Florian Weimer <fweimer@redhat.com>; Lennart
> > Poettering <mzxreary@0pointer.de>; Peter Matthias <matthias.peter@bsi.bund.de>; Marcelo Henrique Cerri
> > <marcelo.cerri@canonical.com>; Neil Horman <nhorman@redhat.com>; Randy Dunlap <rdunlap@infradead.org>; Julia Lawall
> > <julia.lawall@inria.fr>; Dan Carpenter <dan.carpenter@oracle.com>; Andy Lavr <andy.lavr@gmail.com>; Eric Biggers
> > <ebiggers@kernel.org>; Jason A. Donenfeld <Jason@zx2c4.com>; Stephan Müller <smueller@chronox.de>; Petr Tesarik
> > <ptesarik@suse.cz>
> > Subject: Re: [DISCUSSION PATCH 00/41] random: possible ways towards NIST SP800-90B compliance
> >
> > <<< External Email >>>
> > On Fri, Oct 02, 2020 at 01:35:18PM +0000, Van Leeuwen, Pascal wrote:
> > > ** This message and any attachments are for the sole use of the intended recipient(s). It may contain information that is
> > confidential and privileged. If you are not the intended recipient of this message, you are prohibited from printing, copying,
> > forwarding or saving it. Please delete the message and attachments and notify the sender immediately. **
> >
> > As per my legal department requests, this is now ignored and deleted on
> > my system...
> >
> > Hint, it's not a valid footer for public mailing lists...
> >
> > greg k-h
> It's automatically added by our company mail server ... not something I can control at all :-(

Then your company can not contribute in Linux kernel development, as
this is obviously not allowed by such a footer.

Please work with your IT and legal department to fix this.

thanks,

greg k-h
