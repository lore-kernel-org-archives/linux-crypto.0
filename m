From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 17/18] Hibernate: introduced SNAPSHOT_SIG_HASH config
 for select hash algorithm
Date: Sun, 25 Aug 2013 18:43:29 +0200
Message-ID: <20130825164329.GL5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-18-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
To: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1377169317-5959-18-git-send-email-jlee-IBi9RG/b67k@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu 2013-08-22 19:01:56, Lee, Chun-Yi wrote:
> This patch introduced SNAPSHOT_SIG_HASH config for user to select which
> hash algorithm will be used during signature generation of snapshot.
> 
> v2:
> Add define check of oCONFIG_SNAPSHOT_VERIFICATION in snapshot.c before
> declare pkey_hash().
> 
> Reviewed-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
> Signed-off-by: Lee, Chun-Yi <jlee-IBi9RG/b67k@public.gmane.org>
> ---
>  kernel/power/Kconfig    |   46 ++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/power/snapshot.c |   27 ++++++++++++++++++++++-----
>  2 files changed, 68 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
> index b592d88..79b34fa 100644
> --- a/kernel/power/Kconfig
> +++ b/kernel/power/Kconfig
> @@ -78,6 +78,52 @@ config SNAPSHOT_VERIFICATION
>  	  dependent on UEFI environment. EFI bootloader should generate the
>  	  key-pair.
>  
> +choice
> +	prompt "Which hash algorithm should snapshot be signed with?"
> +        depends on SNAPSHOT_VERIFICATION
> +        help
> +          This determines which sort of hashing algorithm will be used during
> +          signature generation of snapshot. This algorithm _must_ be built into
> +	  the kernel directly so that signature verification can take place.
> +	  It is not possible to load a signed snapshot containing the algorithm
> +	  to check the signature on that module.

Like if 1000 ifdefs you already added to the code are not enough, you
make some new ones?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
