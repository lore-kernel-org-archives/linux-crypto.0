From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
Date: Tue, 27 Aug 2013 16:17:22 +0200
Message-ID: <20130827141722.GA23163@amd.pavel.ucw.cz>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-12-git-send-email-jlee@suse.com>
 <20130825162554.GH5171@amd.pavel.ucw.cz>
 <1377594283.20140.3.camel@linux-s257.site>
 <20130827112943.GA20527@amd.pavel.ucw.cz>
 <20130827120142.GA4314@saturn.hollstein.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Manfred Hollstein <mhollstein-zqRNUXuvxA0b1SvskN2V4Q@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
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
	Takashi Iwai <tiwai
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130827120142.GA4314-FGSgn5mWDzkZXJsbVdw/lG363IjY150HP6IUcbMO39o@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Tue 2013-08-27 14:01:42, Manfred Hollstein wrote:
> On Tue, 27 Aug 2013, 13:29:43 +0200, Pavel Machek wrote:
> > > > > @@ -1205,6 +1290,10 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
> > > > >  
> > > > >  	setup_efi_pci(boot_params);
> > > > >  
> > > > > +#ifdef CONFIG_SNAPSHOT_VERIFICATION
> > > > > +	setup_s4_keys(boot_params);
> > > > > +#endif
> > > > > +
> > > > 
> > > > Move ifdef inside the function?
> > > 
> > > OK, I will define a dummy function for non-verification situation.
> > 
> > IIRC you can just put the #ifdef inside the function body. 
> 
> This is certainly not to be invoked on a frequent basis (and therefore
> not on a hot path), but from a more general angle, wouldn't this leave
> a(nother) plain "jsr... rts" sequence without any effect other than
> burning a few cycles? If the whole function call can be disabled
> (ignored) in a certain configuration, it shouldn't call at all, should
> it?

gcc should be able to deal with optimizing that out.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
