From: joeyli <jlee@suse.com>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Thu, 26 Sep 2013 18:43:38 +0800
Message-ID: <1380192218.32302.69.camel__23368.8378743411$1380192270$gmane$org@linux-s257.site>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
	 <1380161957.32302.42.camel@linux-s257.site>
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
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1380161957.32302.42.camel@linux-s257.site>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E5=9B=9B=EF=BC=8C2013-09-26 =E6=96=BC 10:19 +0800=EF=BC=8Cjo=
eyli =E6=8F=90=E5=88=B0=EF=BC=9A
> =E6=96=BC =E4=B8=89=EF=BC=8C2013-09-25 =E6=96=BC 17:25 -0400=EF=BC=8C=
Alan Stern =E6=8F=90=E5=88=B0=EF=BC=9A
> > On Wed, 25 Sep 2013, David Howells wrote:
> >=20
> > > I have pushed some keyrings patches that will likely affect this =
to:
> > >=20
> > > 	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.gi=
t/log/?h=3Dkeys-devel
> > >=20
> > > I intend to ask James to pull these into his next branch.  If he'=
s happy to do
> > > so, I can look at pulling at least your asymmetric keys patch on =
top of them.
> >=20
> > This suggests a point that I raised at the Linux Plumbers conferenc=
e:
> >=20
> > Why are asymmetric keys used for verifying the hibernation image?  =
It
> > seems that a symmetric key would work just as well.  And it would b=
e a
> > lot quicker to generate, because it wouldn't need any high-precisio=
n
> > integer computations.
> >=20
> > Alan Stern
> >=20
> >=20
>=20
> Per my understood, it's like add salt to snapshot when generate
> signature, then remove the salt when store the snapshot to swap. (or
> pass snapshot to userland).
>=20
> Let me explain the symmetric key solution base on my understand:
>=20
>  + EFI stub kernel generate a hash value from a random seed, then sto=
re
> it to EFi boot varaible. It should protected by UEFI secure boot
> environment.
>=20
>  + When hibernate launched:
>     - Kernel create the snapshot image of memory. It's included the
> random hash value(salt) that generated in EFI stub stage.
>     - Then kernel hash the snapshot image, put the hash to snapshot
> header, just like current asymmetric keys solution.
>     - Kernel erase the salt in snapshot image before it go to swap or
> pass to userspace tool.
>=20
>  + When hibernate resume:
>     - Kernel or userspace tool load the snapshot(without salt) from s=
wap
> to temporary memory space.
>     - Kernel fill the salt back to snapshot image in memory, hash it.
>     - Kernel compare the hash with the hash that put in snapshot head=
er.
>     - Verification done! The follow-up action as current solution.
>=20
> Please current me if I missed anything.
>=20
>=20
> Thanks a lot!
> Joey Lee
>=20

=46or the symmetric key solution, I will try HMAC (Hash Message
Authentication Code). It's already used in networking, hope the
performance is not too bad to a big image.


Thanks
Joey Lee
