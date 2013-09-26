From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Thu, 26 Sep 2013 14:06:21 +0200
Message-ID: <20130926120621.GA7537@amd.pavel.ucw.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
 <1380161957.32302.42.camel@linux-s257.site>
 <1380192218.32302.69.camel@linux-s257.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alan Stern <stern@rowland.harvard.edu>,
	David Howells <dhowells@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
	opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <len.brown@intel.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Vojtech Pavlik <vojtech@suse.cz>,
	Matt Fleming <matt.fleming@intel.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
	Rusty Russell <rusty@rustcorp.com.au>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
To: joeyli <jlee@suse.com>
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1380192218.32302.69.camel@linux-s257.site>
Sender: linux-pm-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi!

> For the symmetric key solution, I will try HMAC (Hash Message
> Authentication Code). It's already used in networking, hope the
> performance is not too bad to a big image.

Kernel already supports crc32 of the hibernation image, you may want
to take a look how that is done.

Maybe you want to replace crc32 with cryptographics hash (sha1?) and
then use only hash for more crypto? That way speed of whatever crypto
you do should not be an issue.

Actually...

Is not it as simple as storing hash of hibernation image into NVRAM
and then verifying the hash matches the value in NVRAM on next
startup? No encryption needed. 

And that may even be useful for non-secure-boot people, as it ensures
you boot right image after resume, boot it just once, etc...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
