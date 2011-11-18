From: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>
Subject: Re: [PATCH v7 1/2] arm: tegra: export tegra_chip_uid
Date: Fri, 18 Nov 2011 10:34:35 -0800
Message-ID: <CAOesGMjL6osTnLwOobDT2iObLhrEgUS5pNAZbCcji9z+VYy7Zg@mail.gmail.com>
References: <1321594953-13390-1-git-send-email-vwadekar@nvidia.com>
	<1321594953-13390-2-git-send-email-vwadekar@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>
To: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321594953-13390-2-git-send-email-vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Sender: linux-tegra-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Nov 17, 2011 at 9:42 PM, Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> From: Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>
>
> The crypto driver will need this api to use
> it in the RNG calculations. In order to build
> the crypto driver as a module, tegra_chip_uid
> has to be exported.
>
> Signed-off-by: Henning Heinold <heinold-cPcqOTmdTlv31zTM6d8ziw@public.gmane.org>
> Signed-off-by: Varun Wadekar <vwadekar-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

Acked-by: Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>
