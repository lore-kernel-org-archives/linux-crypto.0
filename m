From: joeyli <jlee@suse.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Thu, 26 Sep 2013 20:56:10 +0800
Message-ID: <1380200170.32302.85.camel__30108.2166065045$1380200197$gmane$org@linux-s257.site>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
	 <1380161957.32302.42.camel@linux-s257.site>
	 <1380192218.32302.69.camel@linux-s257.site>
	 <20130926120621.GA7537@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
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
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20130926120621.GA7537@amd.pavel.ucw.cz>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-09-26 =E6=96=BC 14:06 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> Hi!
>=20
> > For the symmetric key solution, I will try HMAC (Hash Message
> > Authentication Code). It's already used in networking, hope the
> > performance is not too bad to a big image.
>=20
> Kernel already supports crc32 of the hibernation image, you may want
> to take a look how that is done.

In current kernel design, The crc32 is only for the LZO in-kernel
hibernate, doesn't apply to non-compress hibernate and userspace
hibernate.

Put signature to snapshot header can support any kind of caller that's
trigger hibernate. Any userspace hibernate tool will take the snapshot
image from kernel, so, we need put the signature(or hash result) to
snapshot header before userspace write it to anywhere.=20

>=20
> Maybe you want to replace crc32 with cryptographics hash (sha1?) and
> then use only hash for more crypto? That way speed of whatever crypto
> you do should not be an issue.

That speed of hash is calculated from non-compress snapshot image, does
not overlap with crc32.

>=20
> Actually...
>=20
> Is not it as simple as storing hash of hibernation image into NVRAM
> and then verifying the hash matches the value in NVRAM on next
> startup? No encryption needed.=20
>=20
> And that may even be useful for non-secure-boot people, as it ensures
> you boot right image after resume, boot it just once, etc...
>=20
> 									Pavel

The HMAC approach will not encrypt, just put the key of HMAC to boottim=
e
variable.=20

If user doesn't enable UEFI secure boot, that's fine, the key of HMAC
still cannot access in OS runtime.=20
If user enable UEFI secure boot, then that's better! Because all EFI
file will signed by the manufacturers or OSVs to make sure the code is
secure, will not pass the key to runtime.


Thanks a lot!
Joey Lee


--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
