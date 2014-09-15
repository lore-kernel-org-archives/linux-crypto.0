From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Subject: Re: [dm-devel] [PATCH v3 01/12] crypto: LLVMLinux: Add macro to
 remove use of VLAIS in crypto code
Date: Mon, 15 Sep 2014 10:06:54 +0200
Message-ID: <CAHXqBFK=o2Q3CUPWaL_8TDBJbGjfEOx_HnQzooy33wuKWyu5Gw@mail.gmail.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com> <1410766234-1634-2-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: agk@redhat.com, clm@fb.com, David Miller <davem@davemloft.net>,
	fabf@skynet.be, Herbert Xu <herbert@gondor.apana.org.au>,
	jbacik@fb.com, snitzer@redhat.com, tadeusz.struk@intel.com,
	thomas.lendacky@amd.com, linux-ima-user@lists.sourceforge.net,
	qat-linux@intel.com, d.kasatkin@samsung.com,
	Bruce Allan <bruce.w.allan@intel.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	john.griffin@intel.com, linux-raid@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Behan Webster <behanw@converseincode.com>,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ima-devel@lists.sourceforge.net,
	Andrew Morton <akpm@linux-foundation.org>,
	zohar@linux.vnet.ibm.com, linux-btrfs@vger.kernel.org,
	"Serge E. Hallyn" <serge@hallyn.com>
To: device-mapper development <dm-devel@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410766234-1634-2-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

2014-09-15 9:30 GMT+02:00  <behanw@converseincode.com>:
[...]
> +#define SHASH_DESC_ON_STACK(shash, tfm)                             =
     \
> +       char __desc[sizeof(struct shash_desc) +                   \
> +               crypto_shash_descsize(tfm)] CRYPTO_MINALIGN_ATTR; \
> +       struct shash_desc *shash =3D (struct shash_desc *)__desc
> +

char shash##__desc[] or similar? Otherwise it won't work if you use
this macro twice in the same block.

Best Regards,
Micha=C5=82 Miros=C5=82aw
