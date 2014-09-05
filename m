From: Scot Doyle <lkml14@scotdoyle.com>
Subject: AF_ALG inadvertently disabled
Date: Fri, 5 Sep 2014 00:43:31 +0000 (UTC)
Message-ID: <alpine.LNX.2.11.1409042211390.28715@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-crypto@vger.kernel.org
To: Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.scotdoyle.com ([23.226.141.211]:38055 "EHLO
	mx1.scotdoyle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553AbaIEAwo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Sep 2014 20:52:44 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On a laptop without AMD's CCP, compiling 3.17-rc3 with
  # CONFIG_MODULES is not set
  CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
  CONFIG_CRYPTO_DEV_CCP=y
  CONFIG_CRYPTO_DEV_CCP_DD=y
  # CONFIG_CRYPTO_DEV_CCP_CRYPTO is not set
the strace from a test program is
  socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
  bind(3, {sa_family=AF_ALG, sa_data="skcipher\0\0\0\0\0\0"}, 88) = 0
  setsockopt(3, 0x117 /* SOL_?? */, 1, "n) \21\220\25-\364\356\5\2019\336\366\20\273", 16) = 0
  accept(3, 0, NULL)                      = 4
  sendmsg(4, {msg_name(0)=NULL, msg_iov(1)=[{"\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27"..., 512}], msg_controllen=64, {cmsg_len=20, cmsg_level=0x117 /* SOL_??? */, cmsg_type=, ...}, msg_flags=0}, 0) = 512
  read(4, "\322\322\22\25\3\3159\2052Q\356\256lA<\336\245\230a\36!\343\366\26=J\231\254\211x>G"..., 512) = 512


However, when compiling with
  # CONFIG_MODULES is not set
  CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
  CONFIG_CRYPTO_DEV_CCP=y
  CONFIG_CRYPTO_DEV_CCP_DD=y
  CONFIG_CRYPTO_DEV_CCP_CRYPTO=y
the strace from the same test program is
  socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
  bind(3, {sa_family=AF_ALG, sa_data="skcipher\0\0\0\0\0\0"}, 88) = 0
  setsockopt(3, 0x117 /* SOL_?? */, 1, "n) \21\220\25-\364\356\5\2019\336\366\20\273", 16) = 0
  accept(3, 0, NULL)                      = 4
  sendmsg(4, {msg_name(0)=NULL, msg_iov(1)=[{"\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27"..., 512}], msg_controllen=64, {cmsg_len=20, cmsg_level=0x117 /* SOL_??? */, cmsg_type=, ...}, msg_flags=0}, 0) = 512
  read(4, 0x1f48000, 512)                 = -1 ENODEV (No such device)


cryptsetup exhibits the same behavior as the test program.
