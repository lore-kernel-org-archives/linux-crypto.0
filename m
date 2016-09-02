From: PrasannaKumar Muralidharan <prasannatsmkumar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 3/4] hw_random: jz4780-rng: Add RNG node to jz4780.dtsi
Date: Fri, 2 Sep 2016 18:27:17 +0530
Message-ID: <CANc+2y5qm6zdfG5dvway=+80aqkkarSGjfXt+Lq__CiCOTw+Nw@mail.gmail.com>
References: <1472321697-3094-1-git-send-email-prasannatsmkumar@gmail.com>
 <1472321697-3094-4-git-send-email-prasannatsmkumar@gmail.com> <4a7fb1cb-e0d4-31b7-7016-35adb63a659d@imgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: mpm-VDJrAJ4Gl5ZBDgjK7y7TUQ@public.gmane.org, Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
        robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org,
        Ralf Baechle <ralf-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>,
        Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>,
        boris.brezillon-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org, harvey.hunt-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org,
        prarit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Florian Fainelli <f.fainelli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        joshua.henderson-UWL1GkI3JZL3oGB3hsPCZA@public.gmane.org, narmstrong-rdvid1DuHRBWk0Htik3J/w@public.gmane.org,
        Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>,
        linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org
To: Paul Burton <paul.burton-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4a7fb1cb-e0d4-31b7-7016-35adb63a659d-1AXoQHu6uovQT0dZR+AlfA@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

> I don't like this change. The RNG registers are documented as a part of
> the same hardware block as the clock & power stuff which the CGU driver
> handles, and indeed in the M200 SoC there is a power-related register
> after the RNG registers. So shortening the range covered by the CGU
> driver is not the right way to go.

Could not find M200 SoC PM in ingenic's website or ftp. So did not notice this.

> Perhaps you could instead have the CGU driver make use of the syscon
> infrastructure to expose a regmap which your RNG driver could pick up & use?

I will see how to use syscon and provide an updated patch.
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
