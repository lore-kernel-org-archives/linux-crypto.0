Return-Path: <SRS0=36JE=OX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B256BC67839
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Dec 2018 03:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 785052086D
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Dec 2018 03:58:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=thunk.org header.i=@thunk.org header.b="XgFcD58U"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 785052086D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mit.edu
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-crypto-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbeLND6i (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 13 Dec 2018 22:58:38 -0500
Received: from imap.thunk.org ([74.207.234.97]:35382 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbeLND6i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 22:58:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=thunk.org;
         s=ef5046eb; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qWkjphSaSgiwDQOKrxPvsoWFad7dRJ28gWpwIYi3Kbo=; b=XgFcD58UnUvHygDDMWOKa0vVKi
        Nw8SntBuFof1LJq997PBB5vOWC7QsT6w930D3XFdH9JPsUEf/oqk3e3G35Yo+8kH3X/tzpMfvHcYN
        wsmnwgc76G7BmvqNRHj78VVespvdYfxZdHzyZHdlK72xY4Z+ooFPQOl5+ZddOP1HuCW8=;
Received: from root (helo=callcc.thunk.org)
        by imap.thunk.org with local-esmtp (Exim 4.89)
        (envelope-from <tytso@thunk.org>)
        id 1gXecI-0005Xz-F9; Fri, 14 Dec 2018 03:58:22 +0000
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id C687F7A4FE6; Thu, 13 Dec 2018 22:58:21 -0500 (EST)
Date:   Thu, 13 Dec 2018 22:58:21 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     louiscollard@chromium.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, mpm@selenic.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        gary.hook@amd.com, m@bues.ch,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        apronin@chromium.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux@mniewoehner.de, david.bild@xaptum.com
Subject: Re: [PATCH v2] Allow hwrng to initialize crng.
Message-ID: <20181214035821.GD20880@thunk.org>
Mail-Followup-To: "Theodore Y. Ts'o" <tytso@mit.edu>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        louiscollard@chromium.org,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>,
        mpm@selenic.com, Herbert Xu <herbert@gondor.apana.org.au>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, gary.hook@amd.com,
        m@bues.ch, PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        apronin@chromium.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux@mniewoehner.de, david.bild@xaptum.com
References: <20181213091848.81327-1-louiscollard@chromium.org>
 <CAKv+Gu9sWw=VHjYivokAkhGP+p1P15bs3ThfRghARNesW5kyOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9sWw=VHjYivokAkhGP+p1P15bs3ThfRghARNesW5kyOA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
Message-ID: <20181214035821.AXC8kh2t5_RVoYUCbEN4dr6nsIWN5M_b8568DGUyntE@z>

On Thu, Dec 13, 2018 at 10:48:07AM +0100, Ard Biesheuvel wrote:
> > @@ -64,13 +65,19 @@ static size_t rng_buffer_size(void)
> >  static void add_early_randomness(struct hwrng *rng)
> >  {
> >         int bytes_read;
> > -       size_t size = min_t(size_t, 16, rng_buffer_size());
> > +       /* Read enough to initialize crng. */
> > +       size_t size = min_t(size_t,
> > +                           2*CHACHA20_KEY_SIZE,
> 
> This should be as symbolic constant that retains its meaning even if
> we move away from ChaCha20 or modify the current implementation

Also, rng_buffer_size() could be less than 2*hCHACHA20_KEY_SIZE, at
which point your goal wouldn't be realized.  What I'd recommend is to
keep the line:

	size_t size = min_t(size_t, 16, rng_buffer_size());

But to loop until rng_is_initialized() returns true or bytes_read is
0.  If you want to be paranoid, you could also break out of the loop
it isn't initialized after, say, 8 times through the loop.

Cheers,

					- Ted
