From: "Tan Swee Heng" <thesweeheng@gmail.com>
Subject: Possible bug in CTR (and Salsa20) for large test vectors
Date: Sun, 25 Nov 2007 04:07:22 +0800
Message-ID: <fd3e431c0711241207u462cacdfre0ca957cd16a6b58@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: "Herbert Xu" <herbert@gondor.apana.org.au>,
	"Linux Crypto" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.228]:21519 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbXKXUHY (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sat, 24 Nov 2007 15:07:24 -0500
Received: by wr-out-0506.google.com with SMTP id c49so34167wra
        for <linux-crypto@vger.kernel.org>; Sat, 24 Nov 2007 12:07:22 -0800 (PST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I seem to have encountered a bug when encrypting large test vectors.

TEST SETTINGS
I modified tcrypt.c to "ctr(aes,4,8,4)"-encrypt a single large test
vector defined as:
   plaintext = 00...00 (4096 bytes)
   key = 00...00 (32 bytes)
   nonce = 00...00 (4 bytes)
   iv = 00...00 (8 bytes)
   counter = 4 bytes starting from 00...01.

OUTPUT
The output I obtained (using a modified hexdump() in tcrypt.c) is this:
  3992 : e2 0e 5f 84 e9 05 ea 8f
  4000 : 75 f7 2a ac 4f e9 70 12
  4008 : 80 88 db 7a 50 0b 22 cd
  4016 : 2d 23 c8 d1 90 8b 43 14
  4024 : ae 69 5c 8a 49 ba e9 74
  4032 : 71 2a 62 a2 14 14 df 86
  4040 : a6 4c 51 5d 9a cc c3 9e
  4048 : cd e5 24 14 68 8e 5b f6
  4056 : 4d 4f 06 c6 f1 7c 29 03
  4064 : ab c7 50 b2 8e da 2e 34
  4072 : c7 e9 d2 50 99 86 32 d4
  4080 : 44 35 62 42 ef 04 05 8d
  4088 : 4c af 3c 8e be b9 f2 48

Compare with what I obtained using Crypto++:
  3992 : e2 0e 5f 84 e9 05 ea 8f
  4000 : 75 f7 2a ac 4f e9 70 12
  4008 : 67 3e 05 ba c1 56 20 99
  4016 : 80 88 db 7a 50 0b 22 cd
  4024 : 2d 23 c8 d1 90 8b 43 14
  4032 : ae 69 5c 8a 49 ba e9 74
  4040 : 71 2a 62 a2 14 14 df 86
  4048 : a6 4c 51 5d 9a cc c3 9e
  4056 : cd e5 24 14 68 8e 5b f6
  4064 : 4d 4f 06 c6 f1 7c 29 03
  4072 : ab c7 50 b2 8e da 2e 34
  4080 : c7 e9 d2 50 99 86 32 d4
  4088 : 44 35 62 42 ef 04 05 8d

As we can see, half a block (8 bytes) went "missing" at the start of byte 4008.

DIAGNOSIS
I added a prink() after "while (walk.nbytes)" in crypto_ctr_crypt().
On my system, it shows that the 4096 bytes buffer is broken into two
parts such that the first walk.nbytes = 4008 and the second
walk.nbytes = 88. Since 4008 % 16 = 8, therefore bytes 4000 to 4007
are XORed with the first 8 bytes of AES(counter N). The remaining 8
bytes of AES(counter N) are still available and are meant for bytes
4008 to 4015. However they are discarded when N is incremented. Thus
when the 2nd part is encrypted, byte 4008 to 4015 are XORed with the
first 8 bytes of AES(counter N+1) instead. The rest of the stream
slips as a result of this.

RESOLUTION
One idea is to keep state on how many bytes in the AES(counter N)
buffer has been consumed so that N is not incremented unnecessarily.
But there may be inefficiencies associated with these additional
checks. If anyone has better ideas, please feel free to post it. (Note
that salsa20_generic.c has the same problem. So any great ideas for
CTR would be useful to me too. :-)

Swee Heng
