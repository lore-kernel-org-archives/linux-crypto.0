From: Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
Date: Thu, 26 Sep 2013 14:23:03 +0200
Message-ID: <20130926122303.GB30225@suse.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
 <1380161957.32302.42.camel@linux-s257.site>
 <1380192218.32302.69.camel@linux-s257.site>
 <20130926120621.GA7537@amd.pavel.ucw.cz>
 <524426C3.1050501@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>,
	Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
	Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>,
	Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
	James Bottomley <james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>,
	Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, JKosina-IBi9RG/b67k@public.gmane.org,
	Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
	Herbert Xu <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
	"David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>,
	Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>
Return-path: <opensuse-kernel+bounces-5148-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
Content-Disposition: inline
In-Reply-To: <524426C3.1050501-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 26, 2013 at 02:21:23PM +0200, Michal Marek wrote:

> > Is not it as simple as storing hash of hibernation image into NVRAM
> > and then verifying the hash matches the value in NVRAM on next
> > startup? No encryption needed. 
> 
> I think that part of the exercise is to minimize the number of writes to
> the NVRAM. The hash changes with every hibernation, obviously.

The key should, too. 

-- 
Vojtech Pavlik
Director SUSE Labs
