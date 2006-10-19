From: Andreas Jellinghaus <aj@ciphirelabs.com>
Subject: Re: [ACRYPTO] New asynchronous crypto layer (acrypto) release.
Date: Thu, 19 Oct 2006 17:04:19 +0200
Message-ID: <453793F3.1080207@ciphirelabs.com>
References: <20060928120826.GA18063@2ka.mipt.ru> <451BCCDF.5000201@ciphirelabs.com> <20060929094809.GA31117@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.ciphirelabs.net ([217.72.114.64]:50562 "EHLO
	mx1.ciphirelabs.net") by vger.kernel.org with ESMTP
	id S1161437AbWJSPEd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 19 Oct 2006 11:04:33 -0400
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
In-Reply-To: <20060929094809.GA31117@2ka.mipt.ru>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I finally got around testing 2.6.18.1 + acrypto.
but it "does not work" - I usualy boot, enter my
passphrases for rsa key / openssl decrypts some random
bytes with them, and a hex version of those random bytes
is used with dm-setup to initialize a dm-crypt mapping
which again is used for mounting root and swap (or
resume in case it has a suspend image on them).

but with the acrypto patched kernel the system freezes
without any response. the script in the initramfs is not
"set +x" so I'm not sure which command causes the freeze,
so I guess it is either the dm-setup, the resume trigger
(echo to a file in /sys/) or the mount for root or the
swapon.

> As I answered in your first e-mail, yes, you just need to patch 2.6.18
> tree and load one of the crypto provider.

what exactly would be "load one of the crypto providers"?
+# Asynchronous crypto layer
+#
+CONFIG_ACRYPTO=y
+CONFIG_ASYNC_PROVIDER=y
+# CONFIG_CONSUMER is not set
+# CONFIG_ASYNC2OCF_BRIDGE is not set
+
+#
this change to .config should be enough
(ok, 2.6.18.1 also enabled CONFIG_CONNECTOR and CONFIG_PROC_EVENTS).

I documented the setup of my laptop with encryption here:
https://help.ubuntu.com/community/EncryptedFilesystemHowto4

and I can post kernel config etc. if it helps. there was no
kernel message when the machine froze (or more like waiting
for something forever - ctrl-alt-del still worked fine).

note: kernel 2.6.18 was working fine, I didn't try 2.6.18.1
without acrypto changes, but I guess that isn't the issues.
still if you think otherwise, I can give it a try. if there
is some boot option to disable acrypto so dm-crypt will work
as if compiled without acrypto, I would try that too.
is there such an option?

Thanks, Andreas
