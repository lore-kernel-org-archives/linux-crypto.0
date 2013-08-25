From: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
Subject: Re: [PATCH 10/18] efi: Enable secure boot lockdown automatically
 when enabled in firmware
Date: Sun, 25 Aug 2013 17:26:19 +0100
Message-ID: <20130825162618.GA20297@srcf.ucam.org>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-11-git-send-email-jlee@suse.com>
 <20130825162243.GG5171@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
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
	Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130825162243.GG5171-tWAi6jLit6GreWDznjuHag@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Aug 25, 2013 at 06:22:43PM +0200, Pavel Machek wrote:
> On Thu 2013-08-22 19:01:49, Lee, Chun-Yi wrote:
> > From: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > 
> > The firmware has a set of flags that indicate whether secure boot is enabled
> > and enforcing. Use them to indicate whether the kernel should lock itself
> > down.  We also indicate the machine is in secure boot mode by adding the
> > EFI_SECURE_BOOT bit for use with efi_enabled.
> 
> > +	status = efi_call_phys5(sys_table->runtime->get_variable,
> > +				L"SecureBoot", &var_guid, NULL, &datasize, &sb);
> 
> What is this L"..." thing?

http://en.wikipedia.org/wiki/C_syntax#Wide_character_strings
-- 
Matthew Garrett | mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org
