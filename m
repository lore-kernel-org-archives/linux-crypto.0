Return-Path: <SRS0=36JE=OX=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35382 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726500AbeLND6i (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 13 Dec 2018 22:58:38 -0500
Date: Thu, 13 Dec 2018 22:58:21 -0500
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: louiscollard@chromium.org,
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
References: <20181213091848.81327-1-louiscollard@chromium.org>
 <CAKv+Gu9sWw=VHjYivokAkhGP+p1P15bs3ThfRghARNesW5kyOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9sWw=VHjYivokAkhGP+p1P15bs3ThfRghARNesW5kyOA@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

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
