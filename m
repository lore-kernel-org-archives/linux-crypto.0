From: Alden Tondettar <alden.tondettar@gmail.com>
Subject: Re: [PATCH] random: Don't overwrite CRNG state in crng_initialize()
Date: Thu, 9 Feb 2017 02:04:32 -0700
Message-ID: <20170209090432.GA18039@rincewind>
References: <1486611086-2290-1-git-send-email-alden.tondettar@gmail.com>
 <20170209064725.GA4363@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Arnd Bergmann <arnd@arndb.de>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170209064725.GA4363@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 09, 2017 at 07:47:25AM +0100, Greg Kroah-Hartman wrote:
> On Wed, Feb 08, 2017 at 08:31:26PM -0700, Alden Tondettar wrote:
> > In short, the situation is:
> > 
> > A) No usable hardware RNG or arch_get_random() (or we don't trust it...)
> 
> Wait, why would you not trust arch_get_random()?  Is it broken somehow
> on some arches?  If so, why not fix that as well?

arch_get_random() makes use of RDRAND and similar CPU features. Some people
do not wish to trust black-box RNG implementations.

Alden
