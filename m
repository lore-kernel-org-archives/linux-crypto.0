From: Andreas Jellinghaus <aj@ciphirelabs.com>
Subject: Re: [ACRYPTO] New asynchronous crypto layer (acrypto) release.
Date: Fri, 20 Oct 2006 15:34:40 +0200
Message-ID: <4538D070.80203@ciphirelabs.com>
References: <20060928120826.GA18063@2ka.mipt.ru> <451BCCDF.5000201@ciphirelabs.com> <20060929094809.GA31117@2ka.mipt.ru> <453793F3.1080207@ciphirelabs.com> <20061020063111.GA26283@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.ciphirelabs.net ([217.72.114.64]:21653 "EHLO
	mx1.ciphirelabs.net") by vger.kernel.org with ESMTP
	id S1946414AbWJTNey (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Oct 2006 09:34:54 -0400
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
In-Reply-To: <20061020063111.GA26283@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

> Btw, async provider only supports AES-128 in CBC mode, so if you try
> different ciphers, there can be some problems.

my code does

SECTORS=`blockdev --getsize /dev/hda3`

echo 0 $SECTORS crypt aes-cbc-essiv:sha256 $ROOTKEY 0 /dev/hda3 0 \
         |dmsetup create root

so this is not compatible with acrypto I guess :(
any special reason why acrypto is limited this way?

guess that limitation needs to go away before it can be added to
the linux kernel, or some workaround so dm-crypt will fall back on
not using acrypto or something like that in order to not brake existing
and working installations.

Thanks, Andreas
