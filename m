From: Pavel Roskin <proski-mXXj517/zsQ@public.gmane.org>
Subject: Re: Convert arc4 from a cipher into a block cipher
Date: Mon, 05 Apr 2010 16:33:45 -0400
Message-ID: <1270499625.28743.37.camel@mj>
References: <1270280969-11357-1-git-send-email-sebastian@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Andrzej Siewior <sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Return-path: <linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1270280969-11357-1-git-send-email-sebastian-E0PNVn5OA6ohrxcnuTQ+TQ@public.gmane.org>
Sender: linux-wireless-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Sat, 2010-04-03 at 09:49 +0200, Sebastian Andrzej Siewior wrote:
> This patch series converts arc4 into a block cipher and converts all its
> users (except those in staging) to use it. The first two patches ensure
> that two implementations can coexist, the following patches convert each
> user so we remain bisectable.
> - lib80211_crypt_tkip was tested with ipw2200
> - mac80211 was tested with zd1211rw

Are you trying to speed up arc4?  Or you want to simplify the code?  Or
maybe you are trying to make arc4 unsuitable for anything other than WEP
and TKIP?  The later should be fine, actually, considering the known
security issues.

-- 
Regards,
Pavel Roskin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
