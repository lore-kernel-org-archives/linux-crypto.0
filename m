From: Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
Date: Thu, 26 Sep 2013 16:56:33 +0200
Message-ID: <20130926145633.GA572@suse.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
 <1380147414.18835.36.camel@dabdike.int.hansenpartnership.com>
 <20130926002730.GA26857@amd.pavel.ucw.cz>
 <1380162771.18835.47.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1309260819490.18703@pobox.suse.cz>
 <1380206654.18835.56.camel@dabdike.int.hansenpartnership.com>
 <alpine.LNX.2.00.1309261646150.18703@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org,
	"Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	"Lee, Chun-Yi" <jlee-WDPRK7U/wSs@public.gmane.org
To: Jiri Kosina <jiri.kosina-IBi9RG/b67k@public.gmane.org>
Return-path: <opensuse-kernel+bounces-5154-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1309261646150.18703-ztGlSCb7Y1iN3ZZ/Hiejyg@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 26, 2013 at 04:48:00PM +0200, Jiri Kosina wrote:

> > The only two problems I see are
> > 
> >      1. The key isn't generational (any compromise obtains it).  This
> >         can be fixed by using a set of keys generated on each boot and
> >         passing in both K_{N-1} and K_N
> 
> I think this could be easily made optional, leaving the user with choice 
> of faster or "safer" boot.

Ideally, the key should be regenerated on each true reboot and kept the
same if it is just a resume. Unfortunately, I don't see a way to
distinguish those before we call ExitBootServices().

The reasoning behind that is that in the case of a kernel compromise, a
suspended-and-resumed kernel will still be compromised, so there is no
value in passing it a new key. A freshly booted kernel, though, should
get a new key, exactly because the attacker could have obtained a key
from the previous, compromised one.

This speeds up the ususal suspend-and-resume cycle, but provides full
security once the user performs a full reboot.

The question that remains is how to tell in advance.

> >      2. No external agency other than the next kernel can do the
> >         validation since the validating key has to be secret
> 
> This is true, but as you said, the relevance of this seems to be rather 
> questionable.

Indeed, it's hard to imagine a scenario that is also valid within the
secure boot threat model.

-- 
Vojtech Pavlik
Director SUSE Labs
