From: joeyli <jlee@suse.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Thu, 26 Sep 2013 09:36:35 +0800
Message-ID: <1380159395.32302.19.camel__37434.8954567269$1380159444$gmane$org@linux-s257.site>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
	 <29408.1380143073@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
	opensuse-kernel@opensuse.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
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
To: David Howells <dhowells@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <29408.1380143073@warthog.procyon.org.uk>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-09-25 =E6=96=BC 22:04 +0100=EF=BC=8CDa=
vid Howells =E6=8F=90=E5=88=B0=EF=BC=9A
> I have pushed some keyrings patches that will likely affect this to:
>=20
> 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/lo=
g/?h=3Dkeys-devel
>=20

Thanks for your point out, I will respin my asymmetric keys patch base
on this tree.

> I intend to ask James to pull these into his next branch.  If he's ha=
ppy to do
> so, I can look at pulling at least your asymmetric keys patch on top =
of them.
>=20
> It'd be helpful if you could see if you need to make any updates.
>=20
> David
>=20

In LPC, Alan and Vojtech raised another thinking is using symmetric key
to protect the hash of snapshot. It's simpler then using RSA private ke=
y
to sign it.

Even finally we use the symmetric key solution, I will still respin and
resent the patch for add the leading zero byte:

[PATCH V4 07/15] asymmetric keys: explicitly add the leading zero byte
to encoded message

I think keys-devel tree need it.


Thanks a lot!
Joey Lee

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
