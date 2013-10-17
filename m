From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
Date: Thu, 17 Oct 2013 16:18:47 +0200
Message-ID: <3744955.cCTmoQ1ejp@vostro.rjw.lan>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
	opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
	Josh Boyer <jwboyer@redhat.com>,
	Vojtech Pavlik <vojtech@suse.cz>,
	Matt Fleming <matt.fleming@intel.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
	Rusty Russell <rusty@rustcorp.com.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
	"Lee, Chun-Yi" <jlee@suse.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1379206621-18639-1-git-send-email-jlee@suse.com>
Sender: linux-pm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sunday, September 15, 2013 08:56:46 AM Lee, Chun-Yi wrote:
> Hi experts,
> 
> This patchset is the implementation for signature verification of hibernate
> snapshot image. The origin idea is from Jiri Kosina: Let EFI bootloader
> generate key-pair in UEFI secure boot environment, then pass it to kernel
> for sign/verify S4 image.
> 
> Due to there have potential threat from the S4 image hacked, it may causes
> kernel lost the trust in UEFI secure boot. Hacker attack the S4 snapshot
> image in swap partition through whatever exploit from another trusted OS,
> and the exploit may don't need physical access machine.
> 
> So, this patchset give the ability to kernel for parsing RSA private key
> from EFI bootloader, then using the private key to generate the signature
> of S4 snapshot image. Kernel put the signature to snapshot header, and
> verify the signature when kernel try to recover snapshot image to memory.

I wonder what the status of this work is?  Is it considered ready for inclusion
or are you still going to work on it and resubmit?

Rafael

