From: joeyli <jlee@suse.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Thu, 26 Sep 2013 21:20:38 +0800
Message-ID: <1380201638.32302.90.camel__11281.5675246113$1380201694$gmane$org@linux-s257.site>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
	 <1380161957.32302.42.camel@linux-s257.site>
	 <1380192218.32302.69.camel@linux-s257.site>
	 <20130926120621.GA7537@amd.pavel.ucw.cz>  <20130926122210.GA30225@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Machek <pavel@ucw.cz>,
	Alan Stern <stern@rowland.harvard.edu>,
	David Howells <dhowells@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
	opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <len.brown@intel.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Matt Fleming <matt.fleming@intel.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
	Rusty Russell <rusty@rustcorp.com.au>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp.nue.novell.com ([195.135.221.5]:48361 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113Ab3IZNUu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 26 Sep 2013 09:20:50 -0400
In-Reply-To: <20130926122210.GA30225@suse.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-09-26 =E6=96=BC 14:22 +0200=EF=BC=8CVo=
jtech Pavlik =E6=8F=90=E5=88=B0=EF=BC=9A
> On Thu, Sep 26, 2013 at 02:06:21PM +0200, Pavel Machek wrote:
>=20
> > > For the symmetric key solution, I will try HMAC (Hash Message
> > > Authentication Code). It's already used in networking, hope the
> > > performance is not too bad to a big image.
> >=20
> > Kernel already supports crc32 of the hibernation image, you may wan=
t
> > to take a look how that is done.
> >=20
> > Maybe you want to replace crc32 with cryptographics hash (sha1?) an=
d
> > then use only hash for more crypto? That way speed of whatever
> crypto
> > you do should not be an issue.
>=20
> Well, yes, one could skip the CRC when the signing is enabled to gain
> a
> little speedup.=20

In current kernel, CRC is for check the integrity of LZO compressed
image, the purpose is different to check the integrity of snapshot
image.
So, CRC will not in non-compress hibernate or userspace hibernate code
path

On the other hand, attacker can easily change the CRC code in the heade=
r
of LZO hibernate image.

Thanks a lot!
Joey Lee
