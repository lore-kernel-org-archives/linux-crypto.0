From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: [PATCH] random: Don't overwrite CRNG state in crng_initialize()
Date: Thu, 09 Feb 2017 10:26:19 +0100
Message-ID: <12520331.ppYG2MRRyi@positron.chronox.de>
References: <1486611086-2290-1-git-send-email-alden.tondettar@gmail.com> <20170209064725.GA4363@kroah.com> <20170209090432.GA18039@rincewind>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Alden Tondettar <alden.tondettar@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170209090432.GA18039@rincewind>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Am Donnerstag, 9. Februar 2017, 02:04:32 CET schrieb Alden Tondettar:

Hi Alden,

> On Thu, Feb 09, 2017 at 07:47:25AM +0100, Greg Kroah-Hartman wrote:
> > On Wed, Feb 08, 2017 at 08:31:26PM -0700, Alden Tondettar wrote:
> > > In short, the situation is:
> > > 
> > > A) No usable hardware RNG or arch_get_random() (or we don't trust it...)
> > 
> > Wait, why would you not trust arch_get_random()?  Is it broken somehow
> > on some arches?  If so, why not fix that as well?
> 
> arch_get_random() makes use of RDRAND and similar CPU features. Some people
> do not wish to trust black-box RNG implementations.

Furthermore, this function is only implemented on x86. On other arches, it is 
a noop.

Ciao
Stephan
