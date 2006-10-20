From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [ACRYPTO] New asynchronous crypto layer (acrypto) release.
Date: Fri, 20 Oct 2006 10:31:16 +0400
Message-ID: <20061020063111.GA26283@2ka.mipt.ru>
References: <20060928120826.GA18063@2ka.mipt.ru> <451BCCDF.5000201@ciphirelabs.com> <20060929094809.GA31117@2ka.mipt.ru> <453793F3.1080207@ciphirelabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Cc: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from relay.2ka.mipt.ru ([194.85.82.65]:34279 "EHLO 2ka.mipt.ru")
	by vger.kernel.org with ESMTP id S2992516AbWJTGbV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 20 Oct 2006 02:31:21 -0400
To: Andreas Jellinghaus <aj@ciphirelabs.com>
Content-Disposition: inline
In-Reply-To: <453793F3.1080207@ciphirelabs.com>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Oct 19, 2006 at 05:04:19PM +0200, Andreas Jellinghaus (aj@ciphirelabs.com) wrote:
> Hi,
> 
> I finally got around testing 2.6.18.1 + acrypto.
> but it "does not work" - I usualy boot, enter my
> passphrases for rsa key / openssl decrypts some random
> bytes with them, and a hex version of those random bytes
> is used with dm-setup to initialize a dm-crypt mapping
> which again is used for mounting root and swap (or
> resume in case it has a suspend image on them).
> 
> but with the acrypto patched kernel the system freezes
> without any response. the script in the initramfs is not
> "set +x" so I'm not sure which command causes the freeze,
> so I guess it is either the dm-setup, the resume trigger
> (echo to a file in /sys/) or the mount for root or the
> swapon.
> 
> >As I answered in your first e-mail, yes, you just need to patch 2.6.18
> >tree and load one of the crypto provider.
> 
> what exactly would be "load one of the crypto providers"?
> +# Asynchronous crypto layer
> +#
> +CONFIG_ACRYPTO=y
> +CONFIG_ASYNC_PROVIDER=y
> +# CONFIG_CONSUMER is not set
> +# CONFIG_ASYNC2OCF_BRIDGE is not set
> +
> +#
> this change to .config should be enough
> (ok, 2.6.18.1 also enabled CONFIG_CONNECTOR and CONFIG_PROC_EVENTS).

Both are not required.

> I documented the setup of my laptop with encryption here:
> https://help.ubuntu.com/community/EncryptedFilesystemHowto4
> 
> and I can post kernel config etc. if it helps. there was no
> kernel message when the machine froze (or more like waiting
> for something forever - ctrl-alt-del still worked fine).
> 
> note: kernel 2.6.18 was working fine, I didn't try 2.6.18.1
> without acrypto changes, but I guess that isn't the issues.
> still if you think otherwise, I can give it a try. if there
> is some boot option to disable acrypto so dm-crypt will work
> as if compiled without acrypto, I would try that too.
> is there such an option?

If acrypto fails it should automatically switch to sw synchronous mode.
Could you enable debug mode in include/linux/acrypto.h:54 - uncommend 
//#define DEBUG
recompile the kernel and give it a try, so I could check where it stops.

Btw, async provider only supports AES-128 in CBC mode, so if you try
different ciphers, there can be some problems.

Thank you.

> Thanks, Andreas

-- 
	Evgeniy Polyakov
