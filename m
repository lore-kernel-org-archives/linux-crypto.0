From: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: problem with testing a CTR block cipher mode which is
 partially working
Date: Mon, 30 Mar 2015 19:59:48 +0200
Message-ID: <55198F14.1090902@gmail.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBBF4642UAKGQEB35Q3TY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

hello

I am trying to add the CTR (counter) block cipher mode for AES on my Security System driver.

When testing with the tcrypt module I got the following result:
[ 1256.986989] alg: skcipher: Test 1 failed on encryption for ctr-aes-sunxi-ss
[ 1256.987004] 00000000: 87 4d 61 91 b6 20 e3 26 1b ef 68 64 99 0d b6 ce
[ 1256.987013] 00000010: 40 94 25 91 d7 b4 4f 49 ab c1 9d 33 a4 4e f6 54
[ 1256.987023] 00000020: ce 58 d2 f0 01 8f 92 a2 5f 2c bb 66 13 8b 9d 76
[ 1256.987032] 00000030: 30 fa 4a 40 b1 67 2e f3 46 b7 9a 7c ba 91 0b a2

As you can see the first ciphered block is correct (according to testmgr.h), the subsequent blocks are bad.

So Could I assume that the setting of key and IV are good (at least for the first cipher pass.

The number of inputs(register) are limited and I have tested near all the possibility.
Any idea of what could be wrong.

Regards
Thanks in advance
