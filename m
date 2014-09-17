From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH v3 02/12] btrfs: LLVMLinux: Remove VLAIS
Date: Wed, 17 Sep 2014 09:49:20 -0400
Message-ID: <54199160.7090401@fb.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com> <1410766234-1634-3-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <akpm@linux-foundation.org>, <bruce.w.allan@intel.com>,
	<d.kasatkin@samsung.com>, <james.l.morris@oracle.com>,
	<john.griffin@intel.com>, <linux-btrfs@vger.kernel.org>,
	<linux-crypto@vger.kernel.org>,
	<linux-ima-devel@lists.sourceforge.net>,
	<linux-ima-user@lists.sourceforge.net>,
	<linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<linux-security-module@vger.kernel.org>, <neilb@suse.de>,
	<qat-linux@intel.com>, <serge@hallyn.com>,
	<thomas.lendacky@amd.com>, <zohar@linux.vnet.ibm.com>,
	<torvalds@linux-foundation.org>,
	=?UTF-8?B?Vmluw61jaXVzIFRpbnRp?= <viniciustinti@gmail.com>
To: <behanw@converseincode.com>, <agk@redhat.com>,
	<davem@davemloft.net>, <dm-devel@redhat.com>, <fabf@skynet.be>,
	<herbert@gondor.apana.org.au>, <jbacik@fb.com>,
	<snitzer@redhat.com>, <tadeusz.struk@intel.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1410766234-1634-3-git-send-email-behanw@converseincode.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 09/15/2014 03:30 AM, behanw@converseincode.com wrote:
> From: Vin=C3=ADcius Tinti <viniciustinti@gmail.com>
>=20
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a =
C99
> compliant equivalent. This is the original VLAIS struct.
>=20
> struct {
> 	struct shash_desc shash;
> 	char ctx[crypto_shash_descsize(tfm)];
> } desc;
>=20
> This patch instead allocates the appropriate amount of memory using a
> char array using the SHASH_DESC_ON_STACK macro.
>=20
> The new code can be compiled with both gcc and clang.
>=20
> Signed-off-by: Vin=C3=ADcius Tinti <viniciustinti@gmail.com>
> Reviewed-by: Jan-Simon M=C3=B6ller <dl9pf@gmx.de>
> Reviewed-by: Mark Charlebois <charlebm@gmail.com>
> Signed-off-by: Behan Webster <behanw@converseincode.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>

Acked-by: Chris Mason <clm@fb.com>

On the btrfs bits.  Thanks for the v3.

-chris
--
To unsubscribe from this list: send the line "unsubscribe linux-securit=
y-module" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
