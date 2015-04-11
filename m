From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: Counter Size in CTR mode for AES Driver
Date: Sat, 11 Apr 2015 11:40:08 -0400
Message-ID: <CACXcFmnuk3soBgZ0mzFj9pigqPiPdt1Gi3uZXf0hx4Y3f_uozg@mail.gmail.com>
References: <CAHTT9V+VXHYMc1Nkc9hh0Ew7nZy28zTc=rip4op-+BvC80MsTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36355 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbbDKPkI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 11 Apr 2015 11:40:08 -0400
Received: by igblo3 with SMTP id lo3so18503381igb.1
        for <linux-crypto@vger.kernel.org>; Sat, 11 Apr 2015 08:40:08 -0700 (PDT)
In-Reply-To: <CAHTT9V+VXHYMc1Nkc9hh0Ew7nZy28zTc=rip4op-+BvC80MsTw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

sri sowj <srisowj4linux@gmail.com> wrote:

> I have seen multiple open source drivers for AES(CTR) mode for
> different Crypto Hardware Engines, I was not really sure on
> countersize,nonce etc.
> Please can any one provide some info on the following

Not what you asked for, but in case it is useful here is the counter
management code from a version of the random(4) driver that
I am working on:


/*****************************************************************
 * 128-bit counter to mix in when hashing
 ****************************************************************/

static u32 iter_count = 0 ;
static spinlock_t counter_lock ;

/*
 * constants are from SHA-1
 * ones in counter[] are used only once, in initialisation
 * then random data is mixed in there
 */
#define COUNTER_DELTA 0x67452301

static u32 counter[] = {0xEFCDAB89, 0x98BADCFE, 0x10325476, 0xC3D2E1F0} ;

/*
 * Code is based on my own work in the Enchilada cipher:
 * https://aezoo.compute.dtu.dk/doku.php?id=enchilada
 *
 * Mix operations so Hamming weight changes more than for a simple
 * counter. This may not be strictly necessary, but a simple counter
 * can be considered safe only if you trust the crypto completely.
 * Low Hamming weight differences in inputs do allow some attacks on
 * block ciphers or hashes and the high bits of a large counter that
 * is only incremented do not change for aeons.
 *
 * The extra code here is cheap insurance.
 * Somewhat nonlinear since it uses +, XOR and rotation.
 *
 * For discussion, see mailing list thread starting at:
 * http://www.metzdowd.com/pipermail/cryptography/2014-May/021345.html
 */
static void count(void)
{
    spin_lock( &counter_lock ) ;

    /*
    * Limit the switch to < 256 cases
    * should work with any CPU & compiler
    *
    * Five constants used, all primes
    * roughly evenly spaced, around 50, 100, 150, 200, 250
    */
    switch( iter_count )    {
        /*
        * mix three array elements
        * each element is used twice
        * once on left, once on right
        * pattern is circular
        */
        case 47:
            counter[1] += counter[2] ;
            break ;
        case 101:
            counter[2] += counter[3] ;
            break ;
        case 197:
            counter[3] += counter[1] ;
            break ;
        /*
        * inject counter[0] into that loop
        * loop and counter[0] use +=
        * so use ^= here
        */
        case 149:
            counter[1] ^= counter[0] ;
            break ;
        /*
        * restart loop
        * include a rotation for nonlinearity
        */
        case 251:
            counter[0] = ROTL( counter[0], 5) ;
            iter_count = -1 ;
            break ;
        /*
        * for 247 out of every 252 iterations
        * the switch does nothing
        */
        default:
            break ;
    }
    /*
    * counter[0] is almost purely a counter
    * uses += instead of ++ to change Hamming weight more
    * nothing above affects it, except the rotation
    */
    counter[0] += COUNTER_DELTA ;
    iter_count++ ;

    spin_unlock( &counter_lock ) ;
}
