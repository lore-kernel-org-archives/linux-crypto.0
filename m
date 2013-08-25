From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 08/18] Secure boot: Add new capability
Date: Sun, 25 Aug 2013 18:14:28 +0200
Message-ID: <20130825161428.GE5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-9-git-send-email-jlee@suse.com>
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
	Matthew Garrett <mjg@redhat.com>,
	"Lee, Chun-Yi" <jlee@suse.com>
To: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377169317-5959-9-git-send-email-jlee@suse.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu 2013-08-22 19:01:47, Lee, Chun-Yi wrote:
> From: Matthew Garrett <mjg@redhat.com>
> 
> Secure boot adds certain policy requirements, including that root must not
> be able to do anything that could cause the kernel to execute arbitrary code.
> The simplest way to handle this would seem to be to add a new capability
> and gate various functionality on that. We'll then strip it from the initial
> capability set if required.

There was some discussion about this before, right? And I don't think
conclusion was it was acceptable...?

> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Acked-by: Lee, Chun-Yi <jlee@suse.com>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  include/uapi/linux/capability.h |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/include/uapi/linux/capability.h b/include/uapi/linux/capability.h
> index ba478fa..7109e65 100644
> --- a/include/uapi/linux/capability.h
> +++ b/include/uapi/linux/capability.h
> @@ -343,7 +343,11 @@ struct vfs_cap_data {
>  
>  #define CAP_BLOCK_SUSPEND    36
>  
> -#define CAP_LAST_CAP         CAP_BLOCK_SUSPEND
> +/* Allow things that trivially permit root to modify the running kernel */
> +
> +#define CAP_COMPROMISE_KERNEL  37
> +
> +#define CAP_LAST_CAP         CAP_COMPROMISE_KERNEL
>  
>  #define cap_valid(x) ((x) >= 0 && (x) <= CAP_LAST_CAP)
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
