From: joeyli <jlee@suse.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Thu, 26 Sep 2013 10:19:17 +0800
Message-ID: <1380161957.32302.42.camel__30903.6513012417$1380161979$gmane$org@linux-s257.site>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org,
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
To: Alan Stern <stern@rowland.harvard.edu>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-09-25 =E6=96=BC 17:25 -0400=EF=BC=8CAl=
an Stern =E6=8F=90=E5=88=B0=EF=BC=9A
> On Wed, 25 Sep 2013, David Howells wrote:
>=20
> > I have pushed some keyrings patches that will likely affect this to=
:
> >=20
> > 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/=
log/?h=3Dkeys-devel
> >=20
> > I intend to ask James to pull these into his next branch.  If he's =
happy to do
> > so, I can look at pulling at least your asymmetric keys patch on to=
p of them.
>=20
> This suggests a point that I raised at the Linux Plumbers conference:
>=20
> Why are asymmetric keys used for verifying the hibernation image?  It
> seems that a symmetric key would work just as well.  And it would be =
a
> lot quicker to generate, because it wouldn't need any high-precision
> integer computations.
>=20
> Alan Stern
>=20
>=20

Per my understood, it's like add salt to snapshot when generate
signature, then remove the salt when store the snapshot to swap. (or
pass snapshot to userland).

Let me explain the symmetric key solution base on my understand:

 + EFI stub kernel generate a hash value from a random seed, then store
it to EFi boot varaible. It should protected by UEFI secure boot
environment.

 + When hibernate launched:
    - Kernel create the snapshot image of memory. It's included the
random hash value(salt) that generated in EFI stub stage.
    - Then kernel hash the snapshot image, put the hash to snapshot
header, just like current asymmetric keys solution.
    - Kernel erase the salt in snapshot image before it go to swap or
pass to userspace tool.

 + When hibernate resume:
    - Kernel or userspace tool load the snapshot(without salt) from swa=
p
to temporary memory space.
    - Kernel fill the salt back to snapshot image in memory, hash it.
    - Kernel compare the hash with the hash that put in snapshot header=
=2E
    - Verification done! The follow-up action as current solution.

Please current me if I missed anything.


Thanks a lot!
Joey Lee

--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
