Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D104C433EF
	for <linux-crypto@archiver.kernel.org>; Sun,  5 Dec 2021 00:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbhLEBDM (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 4 Dec 2021 20:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbhLEBDL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 4 Dec 2021 20:03:11 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A23C061751
        for <linux-crypto@vger.kernel.org>; Sat,  4 Dec 2021 16:59:45 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id p18so5314541wmq.5
        for <linux-crypto@vger.kernel.org>; Sat, 04 Dec 2021 16:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=49tdzx3S4CEVTdEqaNq8at+kpCXkVGHoZ+cDqpI+JwQ=;
        b=IAkC6Xj9DrrXzK5TYG88sxWKTkcNHn8IowmIqOsoqzB/DOR2UJGEGq9l64eGA8QiXj
         YbnwQq21lbdKPitwAj1JtOGh20OIoQULaEus9sfIpKgYotKtaejQ8J7zkOF5hUhakPnc
         sHxQz3Ct3jiIhLoReK+bokdfYZRYi/pp6u/Jideuixiaj3Oguv+upti7CQ9SQ42e7ZCf
         JCfFjOsI/8VuhKP2kpo0NO+8y4VsEBzK+kJxn5adNEV/m9RJE49Ls2mIau/Iht5dkMjZ
         hBwzB9nnYVEzhqpjWrR+IC1bxubc0pKi/rIIHbMFQaRrT+k2IWSYEmH19JAEqroGApdx
         yqaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=49tdzx3S4CEVTdEqaNq8at+kpCXkVGHoZ+cDqpI+JwQ=;
        b=cvNApP4F55+ahTk7C2rVO1xEUJ/0XoyggknRs1t2ao0uG4JslTgtCfIXsGvvoBDBgd
         wp9OQzOBby9wuAH0E0jGRB317sOJL52RaAoiU5vGoAAsMQklJw+dmYprP/Lz9byHsp5L
         Gwr06AsHM2bqCqvU5XHPPDyxtZ/ZSsVzwTh3fllZmbuFFEw5YQQGMfTvBjHmP9Ixnhd2
         rkWou7p5GTWkbulo20Ko/M34lguULwPkgbaVorqjSIFNzvuFwhN0yss4gdtlIjkaPU0g
         JnQbdO11p9tIguazv8XTS10K+AA2pkJAVku4hkueBwQX4Gnwl543awCNxCkkviHk357k
         qiSA==
X-Gm-Message-State: AOAM532FXfv4V0GYQCcfXc9lMapdusn7qWI8l9SlmWz65ZT1bkoqiq5c
        IOR4t+86zoxuV8TyU5USEmp1dfphf+BsqoduBRVW1NyiMsM4/w==
X-Google-Smtp-Source: ABdhPJxjRHfAWOiyt16LCQ2VeBZ5JkzP4c0pdHs0TioGlkglXwVNR0105oTznGDlG087VEtZ4NpFxtuI6p78OwDzV6w=
X-Received: by 2002:a7b:ca4c:: with SMTP id m12mr27850724wml.119.1638665983444;
 Sat, 04 Dec 2021 16:59:43 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Sun, 5 Dec 2021 08:59:31 +0800
Message-ID: <CACXcFmnEpzp-66JvENsAFTTyehM0bZoGFT6wOBPzkkbGgi7P5A@mail.gmail.com>
Subject: [RFC] random, initialize pool at compile time
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        John Denker <jsd@av8n.com>,
        Stephan Mueller <smueller@chronox.de>,
        Simo Sorce <simo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I will submit this as a patch as soon as I work out how to handle it
in the kernel makefiles. That is not likely to be very soon since
those files are a bit complex, I'm new to them, & I have other things
on my plate just now.

In the meanwhile, it seems worth asking for comments and/or for advice
on the makefiles.

/*
 * Program to select random numbers for initialising things
 * in the random(4) driver.
 *
 * Sandy Harris sandyinchina@gmail.com
 *
 * In general, this falls well short of the ideal solution,
 * which would give every installation (rather than every
 * compiled kernel) a different seed.
 * For that, see John Denker's suggestions at:
 * http://www.av8n.com/computer/htm/secure-random.htm#sec-boot-image
 *
 * However, if every installation compiles a new kernel
 * then this becomes equivalent to Denker's suggestion,
 * or perhaps even better because it uses more random
 * material.
 *
 * Inserting random data at compile time can do no harm and
 * will make some attacks considerably harder. It is not an
 * ideal solution, and not absolutetely necessary, but cheap
 * and probably the best we can do during the build (rather
 * than install) process.
 *
 * This is not strictly necessary if any of these apply:
 *
 *      you have a trustworthy hardware RNG
 *      your CPU has a trustworthy random number instruction
 *      you have secure stored random data
 *
 * In those cases, the device can easily be initialised well;
 * the only difficulty is to ensure that is done early enough.
 * On the other hand, this is easy to do, and even if one or
 * more other methods are used as well this adds a layer for
 * defense in depth.
 *
 * The program takes one optional single-digit command-line option,
 * how many 512-bit contexts to initialise in addition to the
 * input pool
 *      -0, just the pool
 *      -1, initialise a context for Chacha as well
 *          (useful with current driver)
 *      -2, Chacha context plus a 512-bit hash context
 *          (possibe in future driver)
 * If no option is given, it defaults to just the pool.
 *
 * The program:
 *
 *      gets its data from /dev/urandom
 *      produces different output every time it runs
 *      limits the range of Hamming weights
 *      each byte has at least one bit 1, at least one 0
 *
 *      output is formatted as an array declaration
 *      suitable for inclusion by random.c
 *      declared as 64-bit unsigned to align it
 *      writes to stdout, expecting makefile to redirect
 *
 * makefile should also delete the output file after it is
 * used in compilation of random.c, ideally using a secure
 * deletion tool such as shred(1) srm(1) or wipe(1).
 * This forces the file to be rebuilt and a new version
 * used in every compile. It also prevents an enemy just
 * reading an output file in the build directory and
 * getting the data that is used in the current kernel.
 *
 * This is not full protection since they might look in
 * the kernel image or even in the running kernel. But
 * if an enemy has enough privileges to look in those
 * places, then the random driver is nowhere near the
 * most serious security worry.
 *
 * This is certainly done early enough and the data is random
 * enough, but it is not necessarily secret enough.
 *
 * For any machine that compiles its own kernel, this alone might
 * be enough to ensure secure initialisation since only an enemy
 * who already has root could discover this data. Of course even
 * there it should not be used alone, only as one layer of a
 * defense in depth.
 *
 * If a kernel is compiled once then installed on many machines
 * (for example used for an embedded device or in a Linux distro)
 * this is likely of very little value. It complicates an attack
 * somewhat, and might even be too much for some attackers, but
 * it clearly will not stop a serious attacker who has access
 * to another copy of the distro or the device. It may not even
 * slow them down much.
 *
 * In many cases there is a choice. An administrator who
 * distributes software to every machine in an organisation
 * could either compile once and give them all the same kernel
 * or produce a different kernel for each machine; the latter
 * course is not remarkably difficult or expensive.
 *
 * A Linux distro might suggest that users compile a new
 * kernel, or even require it as part of the install
 * process. This might be useful quite apart from the
 * random device, building a kernel optimised for the
 * customer's hardware.
 */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <stdint.h>
#include <ctype.h>
#include <string.h>
#include <linux/random.h>

typedef uint32_t u32 ;
typedef uint64_t u64 ;

/*
 * Configuration information
 */
#define INPUT_POOL_BITS     4096
#define INPUT_POOL_WORDS    (INPUT_POOL_BITS >> 5)
/*
    for Salsa, SHA3 or another hash
*/
#define CONTEXT_BITS        512
#define CONTEXT_WORDS       (CONTEXT_BITS >> 5)
/*
    large enough for any expected usage
    may not all be used
*/
#define MAX_WORDS           (INPUT_POOL_WORDS + (2*CONTEXT_WORDS))
#define MAX_64              (MAX_WORDS >> 1)

u64 data64[MAX_64] ;
u32 *data32 ;

int accept(u32) ;
int hamming(u32);
void usage(void) ;

int urandom ;

int main(int argc, char **argv)
{
        u32 i, x, *p, temp, last, n_contexts, total_words,
total_bytes, total_64 ;
        u64 *p64 ;
        char *ptr ;

    if ((urandom = open("/dev/urandom", O_RDONLY)) == -1)  {
        fprintf(stderr, "gen_random_init: no /dev/urandom, cannot continue\n") ;
        exit(1) ;
    }
    switch(argc)   {
        case 1:
                /* just input pool */
                n_contexts = 0 ;
                break ;
        case 2:
                /*
                 * also some 512-bit contexts
                 * one for chacha
                 * maybe another for 512-bit hash
                 */
                ptr = argv[1] ;
                if (*ptr != '-')
                        usage() ;
                else    {
                        ptr++ ;
                        n_contexts = atoi( ptr ) ;
                }
                break ;
        default:
                usage() ;
        break ;
        }
        if ((n_contexts > 2) || (n_contexts < 0))   {
                fprintf( stderr, "This version of gen_random_init
supports only 0, 1 or 2 contexts\n" ) ;
                usage() ;
        }
        total_words = INPUT_POOL_WORDS + (n_contexts*CONTEXT_WORDS) ;
        total_bytes = total_words << 2 ;
        total_64 = total_words >> 1 ;
        data32 = (u32 *) data64 ;
    /*
     * Initialise the pools with random data
     */
    x = read( urandom, (char *) data64, total_bytes ) ;
    if (x != total_bytes)    {
        fprintf(stderr,"gen_random_init: big read() failed, cannot
continue\n") ;
                exit(1) ;
        }
    /*
     * Replace any array entries that fail criteria
     *
     * In theory, the while loop here could run for some
     * ridiculously long time, or even go infinite
     * In practice, this is astronomically unlikely
     * given any sensible definition of accept() and
     * input that is anywhere near random
    */
        for (i = 0, p = data32 ; i < total_words ; i++, p++)    {
                while (!accept(*p))      {
            x = read( urandom, (char *) &temp, 4) ;
                        if (x != 4)    {
                                fprintf(stderr,"gen_random_init: small
read() failed, cannot continue\n") ;
                                exit(1) ;
                        }
                        *p ^= temp ;
                }
        }
        /*
         * write a file suitable for inclusion
         * declare array as u64 so it is 64-bit aligned
         */
        last = total_64 - 1 ;
        printf("// File generated by gen_random_init.c\n") ;
        printf("// 4096-bit input pool plus %d 512-bit contexts\n\n",
n_contexts ) ;
        printf("#define TOTAL_WORDS %d // size in 32-bit words\n\n",
total_words ) ;
        printf( "static u64 generated_pools[] = {\n" ) ;
        for (i = 0, p64 = data64 ; i < total_64 ; i++, p64++)    {
                printf("0x%016lx", *p64) ;
                if (i == last)
                        printf("\n} ;\n") ;
                else    {
                        putchar(',') ;
                        switch( i % 4 ) {
                        case 3:
                                putchar('\n') ;
                                break ;
                        default:
                                putchar(' ') ;
                        break ;
                        }
                }
        }
}

void usage()
{
    fprintf(stderr, "usage: gen_random_init [-0|-1|-2]\n") ;
    exit(1) ;
}

/*
 * These tests are not strictly necessary
 *
 * We could just use the /dev/urandom output & take what comes
 * Arguably, that would be the best course;
 * "If it ain't broke, don't fix it."
 *
 * Applying any bias here makes output somewhat less random.
 *
 * However, a Hamming weight near 16 gives a better chance
 * of changing the output significantly when the number is
 * used in an addition or xor operation. This is a highly
 * desirable effect.
 *
 * Compromise: apply some bias, but not a very strong one
 */
#define MIN  6
#define MAX (32-MIN)

int accept( u32 u )
{
        int h, i ;
        char *p ;

        /* reject low or high Hamming weights */
        h = hamming(u) ;
        if (( h < MIN ) || ( h > MAX ))
                return(0) ;

        /* at least one 1 and at least one 0 in each byte */
        for (i = 0, p = (char *) &u ; i < 4 ; i++, p++)        {
                switch (*p)      {
                        case '\0':
                        case '\255':
                                return(0) ;
                        default:
                                break ;
                }
        }
        return(1) ;
}

/*
 * Hamming weight is the number of bits that are 1
 * Kernighan's method
 * http://graphics.stanford.edu/~seander/bithacks.html
 */
int hamming( u32 x )
{
        int h ;
        for (h = 0 ; x ; h++)
                x &= (x-1) ; /* clear the least significant bit set */
        return(h) ;
}
