From: Jiri Kosina <jiri.kosina-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate
 snapshot
Date: Thu, 26 Sep 2013 08:24:41 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1309260819490.18703@pobox.suse.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>  <1380147414.18835.36.camel@dabdike.int.hansenpartnership.com>  <20130926002730.GA26857@amd.pavel.ucw.cz> <1380162771.18835.47.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
    David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
    "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
    linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
    linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
    opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org, "Rafael J. Wysocki" <rjw-KKrjLPT3xs0@public.gmane.org>,
    Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
    Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>,
    Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
    Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
    Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>,
    Herbert Xu <herbert-F6s6mLieUQo7FNHlEwC/lvQIK84fMopw@public.gmane.org>,
    "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>,
    Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>,
    Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Return-path: <opensuse-kernel+bounces-5141-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1380162771.18835.47.camel-sFMDBYUN5F8GjUHQrlYNx2Wm91YjaHnnhRte9Li2A+AAvxtiuMwx3w@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
List-Id: linux-crypto.vger.kernel.org

On Wed, 25 Sep 2013, James Bottomley wrote:

> > I don't get this. Why is it important that current kernel can't
> > recreate the signature?
> 
> The thread model is an attack on the saved information (i.e. the suspend
> image) between it being saved by the old kernel and used by the new one.
> The important point isn't that the new kernel doesn't have access to
> K_{N-1} it's that no-one does: the key is destroyed as soon as the old
> kernel terminates however the verification public part P_{N-1} survives.

James,

could you please describe the exact scenario you think that the symmetric 
keys aproach doesn't protect against, while the assymetric key aproach 
does?

The crucial points, which I believe make the symmetric key aproach work 
(and I feel quite embarassed by the fact that I haven't realized this 
initially when coming up with the assymetric keys aproach) are:

- the kernel that is performing the actual resumption is trusted in the 
  secure boot model, i.e. you trust it to perform proper verification

- potentially malicious userspace (which is what we are protecting against 
  -- malicious root creating fake hibernation image and issuing reboot) 
  doesn't have access to the symmetric key

-- 
Jiri Kosina
SUSE Labs
