From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 09/18] Secure boot: Add a dummy kernel parameter that
 will switch on Secure Boot mode
Date: Sun, 25 Aug 2013 18:16:49 +0200
Message-ID: <20130825161649.GF5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-10-git-send-email-jlee@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
	Gary Lin <GLin@suse.com>, Vivek Goyal <vgoyal@redhat.com>,
	"Lee, Chun-Yi" <jlee@suse.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377169317-5959-10-git-send-email-jlee@suse.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

You may want to check subject. If it does something, it is not dummy.

> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -2784,6 +2784,13 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>  			Note: increases power consumption, thus should only be
>  			enabled if running jitter sensitive (HPC/RT) workloads.
>  
> +	secureboot_enable=
> +			[KNL] Enables an emulated UEFI Secure Boot mode.  This
> +			locks down various aspects of the kernel guarded by the
> +			CAP_COMPROMISE_KERNEL capability.  This includes things
> +			like /dev/mem, IO port access, and other areas.  It can
> +			be used on non-UEFI machines for testing purposes.
> +
>  	security=	[SECURITY] Choose a security module to enable at boot.
>  			If this boot parameter is not specified, only the first
>  			security module asking for security registration will be
> diff --git a/kernel/cred.c b/kernel/cred.c
> index e0573a4..c3f4e3e 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -565,6 +565,23 @@ void __init cred_init(void)
>  				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
>  }
>  
> +void __init secureboot_enable()
> +{
> +	pr_info("Secure boot enabled\n");
> +	cap_lower((&init_cred)->cap_bset, CAP_COMPROMISE_KERNEL);
> +	cap_lower((&init_cred)->cap_permitted, CAP_COMPROMISE_KERNEL);
> +}

OTOH you don't implement CAP_COMPROMISE_KERNEL, so it is dummy after
all. But CAP_COMPROMISE_KERNEL is infeasible to implement, right?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
