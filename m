Return-Path: <SRS0=TFX5=DJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B963AC4363D
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 13:34:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72ABA21D94
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Oct 2020 13:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601645640;
	bh=r8sE4T1WJ1sRR0dXb4x/LbPIxOFPFnbbV6tkOMGQhjk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Zfci2GPpTe/VoQilD/zcdPB41Wgex33cvFhOEVYsnUe8xzzY3KCe3hAfjl4UWjCx3
	 T5Mz3hrcryFuNdD352o2lNPt9L4Op8+zJtWNSZmXDy3O9JT8tl4tLyuNc0LFtWtcCd
	 Q0Q5r+FEUeXKv3T2wUzeyDpVf6KNrEwaH+nsRGHk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgJBNd7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Oct 2020 09:33:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:39584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726017AbgJBNd7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Oct 2020 09:33:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A9AD21D92;
        Fri,  2 Oct 2020 13:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601645638;
        bh=r8sE4T1WJ1sRR0dXb4x/LbPIxOFPFnbbV6tkOMGQhjk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ey4Uqhr5SplFwaM0FVnMRpRGViz49oWAGj2/qyXpESRZ9aq5/kbUfEO6dQe7pBUlF
         xQqLlWGvlcIRi7SqSZG8VZhkIr5b2iGmXZ03tf01zpN38/r8n0ihWfvus/RyawOPFz
         efEBAPgnunvIcvuVbe1a2e1LHFnqn7L0gwaWpD0s=
Date:   Fri, 2 Oct 2020 15:33:58 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Torsten Duwe <duwe@lst.de>, "Theodore Y. Ts'o" <tytso@mit.edu>,
        linux-crypto@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
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
Message-ID: <20201002133358.GA3386034@kroah.com>
References: <20200921075857.4424-1-nstange@suse.de>
 <20201002123836.GA14807@lst.de>
 <20201002131555.GD3783@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002131555.GD3783@1wt.eu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 02, 2020 at 03:15:55PM +0200, Willy Tarreau wrote:
> On Fri, Oct 02, 2020 at 02:38:36PM +0200, Torsten Duwe wrote:
> > Almost two weeks passed and these are the "relevant" replies:
> > 
> > Jason personally does not like FIPS, and is afraid of
> > "subpar crypto". Albeit this patch set strictly isn't about
> > crypto at all; the crypto subsystem is in the unlucky position
> > to just depend on a good entropy source.
> > 
> > Greg claims that Linux (kernel) isn't about choice, which is clearly
> > wrong.
> 
> I think there's a small misunderstanding here, my understanding is
> that for quite a while, the possibilities offered by the various
> random subsystems or their proposed derivative used to range from
> "you have to choose between a fast system that may be vulnerable
> to some attacks, a system that might not be vulnerable to certain
> attacks but might not always boot, or a slow system not vulnerable
> to certain attacks". Greg's point seems to be that if we add an
> option, it means it's yet another tradeoff between these possibilities
> and that someone will still not be happy at the end of the chain. If
> the proposed solution covers everything at once (performance,
> reliability, unpredictability), then there probably is no more reason
> for keeping alternate solutions at all, hence there's no need to give
> the user the choice between multiple options when only one is known
> to always be valid. At least that's how I see it and it makes sense
> to me.

Thanks for spelling it out in much more detail than I was willing to :)

thanks,

greg k-h
