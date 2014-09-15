From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v3 11/12] security, crypto: LLVMLinux: Remove VLAIS from ima_crypto.c
Date: Mon, 15 Sep 2014 07:21:46 -0700
Message-ID: <CA+55aFx8FN2Rq+d3v9rsDbTyX3hwm6TvudvZrL5wgf7fX3aQjA@mail.gmail.com>
References: <1410766234-1634-1-git-send-email-behanw@converseincode.com>
	<1410766234-1634-12-git-send-email-behanw@converseincode.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Alasdair G Kergon <agk@redhat.com>, Chris Mason <clm@fb.com>,
	David Miller <davem@davemloft.net>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Fabian Frederick <fabf@skynet.be>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Josef Bacik <jbacik@fb.com>, Mike Snitzer <snitzer@redhat.com>,
	tadeusz.struk@intel.com, Andrew Morton <akpm@linux-foundation.org>,
	Bruce Allan <bruce.w.allan@intel.com>,
	Dmitry Kasatkin <d.kasatkin@samsung.com>,
	James Morris <james.l.morris@oracle.com>,
	john.griffin@intel.com, linux-btrfs <linux-btrfs@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	linux-ima-devel@lists.sourceforge.net,
	linux-ima-user@lists.sourceforge.net,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
	LSM List <linux-security-module@vger.kernel.org>,
	Neil Brown <neilb@suse.de>, qat-lin
To: Behan Webster <behanw@converseincode.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410766234-1634-12-git-send-email-behanw@converseincode.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, Sep 15, 2014 at 12:30 AM,  <behanw@converseincode.com> wrote:
> From: Behan Webster <behanw@converseincode.com>
>
> Replaced the use of a Variable Length Array In Struct (VLAIS) with a C99
> compliant equivalent. This patch allocates the appropriate amount of memory
> using a char array using the SHASH_DESC_ON_STACK macro.

You only made the first case use SHASH_DESC_ON_STACK, the two other
cases you left in the ugly format. Was that just an oversight, or was
there some reason for it?

             Linus
