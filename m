From: joeyli <jlee@suse.com>
Subject: Re: [PATCH V4 13/15] Hibernate: introduced SNAPSHOT_SIG_HASH
 config for select hash algorithm
Date: Thu, 26 Sep 2013 09:43:39 +0800
Message-ID: <1380159819.32302.24.camel__5852.34061950377$1380159864$gmane$org@linux-s257.site>
References: <1379206621-18639-1-git-send-email-jlee@suse.com>
	 <1379206621-18639-14-git-send-email-jlee@suse.com>
	 <20130918134535.GA3748@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org,
	linux-pm@vger.kernel.org, linux-crypto@vger.kernel.org,
	opensuse-kernel@opensuse.org, David Howells <dhowells@redhat.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Len Brown <len.brown@intel.com>,
	Josh Boyer <jwboyer@redhat.com>,
	Vojtech Pavlik <vojtech@suse.cz>,
	Matt Fleming <matt.fleming@intel.com>,
	James Bottomley <james.bottomley@hansenpartnership.com>,
	Greg KH <gregkh@linuxfoundation.org>, JKosina@suse.com,
	Rusty Russell <rusty@rustcorp.com.au>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20130918134535.GA3748@amd.pavel.ucw.cz>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

=E6=96=BC =E4=B8=89=EF=BC=8C2013-09-18 =E6=96=BC 15:45 +0200=EF=BC=8CPa=
vel Machek =E6=8F=90=E5=88=B0=EF=BC=9A
> On Sun 2013-09-15 08:56:59, Lee, Chun-Yi wrote:
> > This patch introduced SNAPSHOT_SIG_HASH config for user to select w=
hich
> > hash algorithm will be used during signature generation of snapshot=
=2E
>=20
> This series is big enough already... and who is going to test it?

The hash config not just for testing, it's relate to the performance an=
d
secure between different hash algorithms.

There have person raised in LPC say he don't like SHA algorithm.

> There's no need to make hash configurable. Just select one that works=
=2E
> =09
> 									Pavel
>=20

SHA1 has good performance, and SHA512 has better security, which one yo=
u
like it?


Thanks a lot!
Joey Lee



--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
