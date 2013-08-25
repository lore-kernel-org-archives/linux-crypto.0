From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 13/18] Hibernate: Avoid S4 sign key data included in
 snapshot image
Date: Sun, 25 Aug 2013 18:39:31 +0200
Message-ID: <20130825163931.GJ5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-14-git-send-email-jlee@suse.com>
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
In-Reply-To: <1377169317-5959-14-git-send-email-jlee@suse.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu 2013-08-22 19:01:52, Lee, Chun-Yi wrote:
> This patch add swsusp_page_is_sign_key() method to hibernate_key.c and
> check the page is S4 sign key data when collect saveable page in
> snapshot.c to avoid sign key data included in snapshot image.
> 
> Reviewed-by: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
> ---
>  kernel/power/snapshot.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
> index 72e2911..9e4c94b 100644
> --- a/kernel/power/snapshot.c
> +++ b/kernel/power/snapshot.c
> @@ -860,6 +860,9 @@ static struct page *saveable_highmem_page(struct zone *zone, unsigned long pfn)
>  
>  	BUG_ON(!PageHighMem(page));
>  
> +	if (swsusp_page_is_sign_key(page))
> +		return NULL;
> +
>  	if (swsusp_page_is_forbidden(page) ||  swsusp_page_is_free(page) ||
>  	    PageReserved(page))
>  		return NULL;

Just do set_page_forbidden() on your page?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
