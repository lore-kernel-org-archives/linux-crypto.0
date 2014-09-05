From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: AF_ALG inadvertently disabled
Date: Fri, 5 Sep 2014 08:57:14 -0500
Message-ID: <5409C13A.2040307@amd.com>
References: <alpine.LNX.2.11.1409042211390.28715@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Scot Doyle <lkml14@scotdoyle.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0108.outbound.protection.outlook.com ([65.55.169.108]:61120
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932201AbaIEON3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Sep 2014 10:13:29 -0400
In-Reply-To: <alpine.LNX.2.11.1409042211390.28715@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 09/04/2014 07:43 PM, Scot Doyle wrote:
> On a laptop without AMD's CCP, compiling 3.17-rc3 with
>    # CONFIG_MODULES is not set
>    CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
>    CONFIG_CRYPTO_DEV_CCP=y
>    CONFIG_CRYPTO_DEV_CCP_DD=y
>    # CONFIG_CRYPTO_DEV_CCP_CRYPTO is not set
> the strace from a test program is
>    socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
>    bind(3, {sa_family=AF_ALG, sa_data="skcipher\0\0\0\0\0\0"}, 88) = 0
>    setsockopt(3, 0x117 /* SOL_?? */, 1, "n) \21\220\25-\364\356\5\2019\336\366\20\273", 16) = 0
>    accept(3, 0, NULL)                      = 4
>    sendmsg(4, {msg_name(0)=NULL, msg_iov(1)=[{"\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27"..., 512}], msg_controllen=64, {cmsg_len=20, cmsg_level=0x117 /* SOL_??? */, cmsg_type=, ...}, msg_flags=0}, 0) = 512
>    read(4, "\322\322\22\25\3\3159\2052Q\356\256lA<\336\245\230a\36!\343\366\26=J\231\254\211x>G"..., 512) = 512
>
>
> However, when compiling with
>    # CONFIG_MODULES is not set
>    CONFIG_CRYPTO_MANAGER_DISABLE_TESTS=y
>    CONFIG_CRYPTO_DEV_CCP=y
>    CONFIG_CRYPTO_DEV_CCP_DD=y
>    CONFIG_CRYPTO_DEV_CCP_CRYPTO=y
> the strace from the same test program is
>    socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
>    bind(3, {sa_family=AF_ALG, sa_data="skcipher\0\0\0\0\0\0"}, 88) = 0
>    setsockopt(3, 0x117 /* SOL_?? */, 1, "n) \21\220\25-\364\356\5\2019\336\366\20\273", 16) = 0
>    accept(3, 0, NULL)                      = 4
>    sendmsg(4, {msg_name(0)=NULL, msg_iov(1)=[{"\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27\27"..., 512}], msg_controllen=64, {cmsg_len=20, cmsg_level=0x117 /* SOL_??? */, cmsg_type=, ...}, msg_flags=0}, 0) = 512
>    read(4, 0x1f48000, 512)                 = -1 ENODEV (No such device)
>

Because ccp-crypto isn't built as a module it will register the
algorithms even if a CCP device isn't there. I'll work up a patch
that checks for the presence of the CCP and only register the
algorithms if a CCP is there.

Thanks,
Tom

>
> cryptsetup exhibits the same behavior as the test program.
>
