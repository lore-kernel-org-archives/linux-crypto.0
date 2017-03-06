From: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/1] ARM: dts: NSP: Add crypto (SPU) to dtsi
Date: Mon, 6 Mar 2017 11:22:54 -0800
Message-ID: <fd877ab2-48db-a677-b539-ba5ed55e75c6@gmail.com>
References: <1487798543-34229-1-git-send-email-steven.lin1@broadcom.com>
 <66ba937a-f1c3-1cae-ff2e-46a9d9c97344@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: bcm-kernel-feedback-list-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        rob.rice-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>,
        herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
        linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org, ray.jui-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        scott.branden-dY08KVG/lbpWk0Htik3J/w@public.gmane.org, jon.mason-dY08KVG/lbpWk0Htik3J/w@public.gmane.org,
        mark.rutland-5wv7dgnIgG8@public.gmane.org
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <66ba937a-f1c3-1cae-ff2e-46a9d9c97344-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On 02/28/2017 12:31 PM, Florian Fainelli wrote:
> On 02/22/2017 01:22 PM, Steve Lin wrote:
>> Adds crypto hardware (SPU) to Northstar Plus device tree file.
>>
>> Signed-off-by: Steve Lin <steven.lin1-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> 
> Applied, thanks!

And dropped, since there is a dependency on "ARM: dts: NSP: Add mailbox
(PDC) to NSP" to be applied first.

Let's wait for the mailbox maintainer to chime in before I apply the
following patches (in that order):

ARM: dts: NSP: Add mailbox (PDC) to NSP
ARM: dts: NSP: Add crypto (SPU) to dtsi

Thanks!
-- 
Florian
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
