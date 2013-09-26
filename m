From: Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC V4 PATCH 00/15] Signature verification of hibernate snapshot
Date: Thu, 26 Sep 2013 14:22:10 +0200
Message-ID: <20130926122210.GA30225@suse.cz>
References: <Pine.LNX.4.44L0.1309251723001.26508-100000@netrider.rowland.org>
 <1380161957.32302.42.camel@linux-s257.site>
 <1380192218.32302.69.camel@linux-s257.site>
 <20130926120621.GA7537@amd.pavel.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>,
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
	"H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>,
	Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Return-path: <opensuse-kernel+bounces-5147-glsk-opensuse-kernel=m.gmane.org-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Post: <mailto:opensuse-kernel-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:opensuse-kernel+help-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Subscribe: <mailto:opensuse-kernel+subscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Unsubscribe: <mailto:opensuse-kernel+unsubscribe-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Owner: <mailto:opensuse-kernel+owner-stAJ6ESoqRxg9hUCZPvPmw@public.gmane.org>
List-Archive: <http://lists.opensuse.org/opensuse-kernel/>
Content-Disposition: inline
In-Reply-To: <20130926120621.GA7537-tWAi6jLit6GreWDznjuHag@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

On Thu, Sep 26, 2013 at 02:06:21PM +0200, Pavel Machek wrote:

> > For the symmetric key solution, I will try HMAC (Hash Message
> > Authentication Code). It's already used in networking, hope the
> > performance is not too bad to a big image.
> 
> Kernel already supports crc32 of the hibernation image, you may want
> to take a look how that is done.
> 
> Maybe you want to replace crc32 with cryptographics hash (sha1?) and
> then use only hash for more crypto? That way speed of whatever crypto
> you do should not be an issue.

Well, yes, one could skip the CRC when the signing is enabled to gain a
little speedup.

> Actually...
> 
> Is not it as simple as storing hash of hibernation image into NVRAM
> and then verifying the hash matches the value in NVRAM on next
> startup? No encryption needed. 

First, there is no encryption going on. Only doing a HMAC (digest (hash)
using a key) of the image.

Second, since NVRAM is accessible through efivarsfs, storing the hash in
NVRAM wouldn't prevent an attacker from modifying the hash to match a
modified image.

There is a reason why the key for the HMAC is stored in the NVRAM in a
BootServices variable that isn't accessible from the OS and is
write-protected on hardware level from the OS.

> And that may even be useful for non-secure-boot people, as it ensures
> you boot right image after resume, boot it just once, etc...

The HMAC approach isn't much more complicated, and it gives you all
these benefits even with secure boot disabled.

-- 
Vojtech Pavlik
Director SUSE Labs
