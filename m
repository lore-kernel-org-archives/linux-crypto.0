From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Re: Problem with RSA test from testmgr
Date: Tue, 28 Feb 2017 23:35:04 +0100
Message-ID: <9482066.IEBbAWS9B8@positron.chronox.de>
References: <20170228155953.GA1732@Red> <1836837.jAzr4JNxJu@tauon.atsec.com> <20170228164553.GA2155@Red>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Corentin Labbe <clabbe.montjoie@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:35508 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751552AbdB1Wfg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Feb 2017 17:35:36 -0500
In-Reply-To: <20170228164553.GA2155@Red>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Dienstag, 28. Februar 2017, 17:45:53 CET schrieb Corentin Labbe:

Hi Corentin,

> On Tue, Feb 28, 2017 at 05:08:35PM +0100, Stephan Müller wrote:
> > Am Dienstag, 28. Februar 2017, 16:59:53 CET schrieb Corentin Labbe:
> > 
> > Hi Corentin,
> > 
> > > hello
> > > 
> > > I work on the sun8i-ce crypto accelerator and I have some problem with
> > > the
> > > RSA part.
> > > 
> > > The RSA register fail at the first RSA test (encrypt 512bit) with this
> > > output: [ 8480.146843] alg: akcipher: encrypt test failed. Invalid
> > > output
> > > [ 8480.146871] 00000000: 6e 7c 8a 75 e7 30 80 d1 5e ab 9b db a2 cf ed db
> > > [ 8480.146897] 00000010: c9 b2 db 43 bd 9a b9 75 27 f3 73 d9 73 b7 81 8c
> > > [ 8480.146921] 00000020: 49 e8 45 fc 43 44 f5 6d f0 f7 b8 f2 ae 6b ae 49
> > > [ 8480.146946] 00000030: 1b 8e 50 c6 88 4e 99 09 78 14 f2 5d 99 c3 7f f9
> > > [ 8480.146995] alg: akcipher: test 1 failed for rsa-sun8i-ce, err=-22
> > > 
> > > But with the same parameters (msg, n, e) openssl give me exactly this
> > > output.
> > > 
> > > So what I miss for made it work ?
> > > In which format testmgr expect the output data ?
> > 
> > The output should be simply the binary string from the modular
> > exponentiation operation.
> > 
> > What I am wondering is: the output logged above is not found in the
> > expected values of testmgr.h. Which input data or test vectors do you
> > use?
> > 
> > Ciao
> > Stephan
> 
> I use the first test from rsa_tv_template in crypto/testmgr.h
> The test fail on the encrypt operation.
> 
> I have put below the openssl program that give me the same output than my
> hardware accelerator with the same parameters.

I would think the issue is that the OpenSSL BIGNUM lib has some issues: when 
calculating m^e mod n, m has to be equal to the key size. The kernel's MPI 
code handles the case where m is smaller than the key size.

Note, in your code below, ptext is the 8 bytes from ptext_ex plus trailing 
zeroes whereas the kernel uses just the 8 bytes.

It seems that your implementation has the same issue.

What about the following test: change vector->m to be 64 bytes (i.e. 
RSA_size(key) in size in testmgr.h and check the output of crypto/rsa.c, 
openssl's output with the app below and your RSA hardware.
> 
> Regards
> 
> 
> #include <stdio.h>
> #include <string.h>
> #include <openssl/crypto.h>
> #include <openssl/err.h>
> #include <openssl/bn.h>
> #include <openssl/rsa.h>
> 
> static const unsigned char n[] =
> "\x00\xAA\x36\xAB\xCE\x88\xAC\xFD\xFF\x55\x52\x3C\x7F\xC4\x52\x3F"
> "\x90\xEF\xA0\x0D\xF3\x77\x4A\x25\x9F\x2E\x62\xB4\xC5\xD9\x9C\xB5"
> "\xAD\xB3\x00\xA0\x28\x5E\x53\x01\x93\x0E\x0C\x70\xFB\x68\x76\x93"
> "\x9C\xE6\x16\xCE\x62\x4A\x11\xE0\x08\x6D\x34\x1E\xBC\xAC\xA0\xA1"
> "\xF5";
> static const unsigned char e[] = "\x11";
> 
> int main(int argc, char *argv[])
> {
> 	static unsigned char ptext_ex[] = "\x54\x85\x9b\x34\x2c\x49\xea\x2a";
> 	RSA *key;
> 	int num, i;
> 	int plen = sizeof(ptext_ex) - 1;
> 	unsigned char *ctext = malloc(256);
> 	unsigned char *ptext = malloc(256);
> 	unsigned char *ptextp = malloc(256);
> 
> 	CRYPTO_malloc_debug_init();
> 	CRYPTO_dbg_set_options(V_CRYPTO_MDEBUG_ALL);
>         CRYPTO_mem_ctrl(CRYPTO_MEM_CHECK_ON);
> 
> 	memset(ptextp, 0, 256);
> 	memcpy(ptextp, ptext_ex, plen);
> 
> 	key = RSA_new();
> 
> 	key->n = BN_bin2bn(n, sizeof(n)-1, key->n);
> 	key->e = BN_bin2bn(e, sizeof(e)-1, key->e);
> 
> 	num = RSA_public_encrypt(RSA_size(key), ptextp, ctext, key,
> RSA_NO_PADDING);
> 
> 	printf("Result %d plen=%d\n", num, plen);
> 	for (i = 0; i < num; i++)
> 		printf("%02x ", ctext[i]);
> 	printf("\n");
> 	return 0;
> }


Ciao
Stephan
