From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH v12 3/4] Linux Random Number Generator
Date: Wed, 19 Jul 2017 08:34:47 +0200
Message-ID: <20170719063447.GA13740@kroah.com>
References: <3910055.ntkqcq1Chb@positron.chronox.de>
 <1780567.qGdv4EjEMp@positron.chronox.de>
 <20170718210816.o6c4iziaqj5dnnd3@thunk.org>
 <4766174.b2XBWsRgGl@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Theodore Ts'o <tytso@mit.edu>,
        "Jason A. Donenfeld" <jason@zx2c4.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4766174.b2XBWsRgGl@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Jul 19, 2017 at 08:22:18AM +0200, Stephan Müller wrote:
> Am Dienstag, 18. Juli 2017, 23:08:16 CEST schrieb Theodore Ts'o:
> 
> Hi Theodore,
> > 
> > I've been trying to take the best features and suggestions from your
> > proposal and integrating them into /dev/random already.  Things that
> > I've chosen not take is basically because I disbelieve that the Jitter
> > RNG is valid.  And that's mostly becuase I trust Peter Anvin (who has
> > access to Intel chip architects, who has expressed unease) more than
> > you.  (No hard feelings).
> 
> I am unsure why you always point to the Jitter RNG. This is one noise source 
> to keep or to remove -- at least it provides more data during early boot than 
> any other noise source we currently have.
> 
> In the email [1] I have expressed the core concerns I see -- none of them 
> address the need to keep the Jitter RNG as one noise source. To address those, 
> a very deep dive into random.c needs to be made.
> 
> Such deep dive has the potential to be disruptive. Therefore, doesn't it make 
> more sense to have such conceptual changes rather covered in a separate 
> implementation?

No, it makes more sense to send individual patches addressing your
concerns to the existing random driver.  Again, that's how
kernel development has always worked.

thanks,

greg k-h
