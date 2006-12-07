From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC][PATCH] Pseudo-random number generator
Date: Thu, 7 Dec 2006 16:06:33 +0100
Message-ID: <200612071606.33951.arnd@arndb.de>
References: <1164979155.5882.23.camel@bender>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1032305AbWLGPG7@vger.kernel.org>
To: Jan Glauber <jan.glauber@de.ibm.com>
In-Reply-To: <1164979155.5882.23.camel@bender>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Friday 01 December 2006 14:19, Jan Glauber wrote:
> I've chosen the char driver since it allows the user to decide which pseudo-random
> numbers he wants to use. That means there is a new interface for the s390
> PRNG, called /dev/prandom.
> 
> I would like to know if there are any objections, especially with the chosen device
> name.

This may be a stupid question, but what is it _good_ for? My understanding is
that the crypt_s390_kmc() opcodes work in user mode as well as kernel mode, so
you should not need a character device at all, but maybe just a small tool
that spits prandom data to stdout.

	Arnd <><
