From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v6 1/7] drm/tilcdc: ensure nonatomic iowrite64 is not used
Date: Fri, 4 Aug 2017 09:47:37 -0600
Message-ID: <15c19bbe-a178-5c60-530e-14229bfdc906@deltatee.com>
References: <20170803183018.5889-1-logang@deltatee.com>
 <20170803183018.5889-2-logang@deltatee.com>
 <2b41b02c-07e3-b927-f276-a29480f94285@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        =?UTF-8?Q?Horia_Geant=c4=83?= <horia.geanta@nxp.com>,
        Stephen Bates <sbates@raithlin.com>,
        David Airlie <airlied@linux.ie>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-ntb@googlegroups.com, linux-crypto@vger.kernel.org,
        Jyri Sarha <jsarha@ti.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <2b41b02c-07e3-b927-f276-a29480f94285@ti.com>
Content-Language: en-US
Sender: linux-arch-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org



On 04/08/17 07:03 AM, Tomi Valkeinen wrote:
> I haven't really followed the discussion on this, but if the tilcdc's
> use of iowrite64 causes (real) problems/complications elsewhere, I think
> we could drop it.

Well, that's up to you. The patch I submitted should still be correct
though, and if arm ever gets a proper atomic iowrite64 implementation it
would be good to use it. So in an annotative sense it's nice to keep the
function call in there.

Thanks,

Logan
