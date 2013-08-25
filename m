From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH 10/18] efi: Enable secure boot lockdown automatically
 when enabled in firmware
Date: Sun, 25 Aug 2013 18:22:43 +0200
Message-ID: <20130825162243.GG5171@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-11-git-send-email-jlee@suse.com>
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
In-Reply-To: <1377169317-5959-11-git-send-email-jlee@suse.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu 2013-08-22 19:01:49, Lee, Chun-Yi wrote:
> From: Matthew Garrett <mjg@redhat.com>
> 
> The firmware has a set of flags that indicate whether secure boot is enabled
> and enforcing. Use them to indicate whether the kernel should lock itself
> down.  We also indicate the machine is in secure boot mode by adding the
> EFI_SECURE_BOOT bit for use with efi_enabled.

> +	status = efi_call_phys5(sys_table->runtime->get_variable,
> +				L"SecureBoot", &var_guid, NULL, &datasize, &sb);

What is this L"..." thing?
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
