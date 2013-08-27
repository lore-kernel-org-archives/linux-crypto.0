From: Manfred Hollstein <mhollstein-zqRNUXuvxA0b1SvskN2V4Q@public.gmane.org>
Subject: Re: [PATCH 11/18] Hibernate: introduced RSA key-pair to verify
 signature of snapshot
Date: Tue, 27 Aug 2013 14:01:42 +0200
Message-ID: <20130827120142.GA4314@saturn.hollstein.homelinux.org>
References: <1377169317-5959-1-git-send-email-jlee@suse.com>
 <1377169317-5959-12-git-send-email-jlee@suse.com>
 <20130825162554.GH5171@amd.pavel.ucw.cz>
 <1377594283.20140.3.camel@linux-s257.site>
 <20130827112943.GA20527@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Takashi Iwai <tiwai-l3A5Bk7waGM@public.gmane.org>
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Return-path: <opensuse-kernel+bounces-5014-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
Content-Disposition: inline
In-Reply-To: <20130827112943.GA20527-tWAi6jLit6GreWDznjuHag@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

On Tue, 27 Aug 2013, 13:29:43 +0200, Pavel Machek wrote:
> > > > @@ -1205,6 +1290,10 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
> > > >  
> > > >  	setup_efi_pci(boot_params);
> > > >  
> > > > +#ifdef CONFIG_SNAPSHOT_VERIFICATION
> > > > +	setup_s4_keys(boot_params);
> > > > +#endif
> > > > +
> > > 
> > > Move ifdef inside the function?
> > 
> > OK, I will define a dummy function for non-verification situation.
> 
> IIRC you can just put the #ifdef inside the function body. 

This is certainly not to be invoked on a frequent basis (and therefore
not on a hot path), but from a more general angle, wouldn't this leave
a(nother) plain "jsr... rts" sequence without any effect other than
burning a few cycles? If the whole function call can be disabled
(ignored) in a certain configuration, it shouldn't call at all, should
it?

Cheers.

l8er
manfred
