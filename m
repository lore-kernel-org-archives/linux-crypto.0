From: Gary R Hook <gary.hook@amd.com>
Subject: Re: [PATCH v3 RESEND 4/5] crypto: ccp - rename ccp driver initialize
 files as sp device
Date: Mon, 3 Jul 2017 10:51:07 -0500
Message-ID: <7d4ea998-2ed1-189d-0274-d03609f7e4dd@amd.com>
References: <20170629165406.13463-1-brijesh.singh@amd.com>
 <20170629165406.13463-5-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
To: "Singh, Brijesh" <brijesh.singh@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-sn1nam01on0073.outbound.protection.outlook.com ([104.47.32.73]:45120
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752639AbdGCPva (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Jul 2017 11:51:30 -0400
In-Reply-To: <20170629165406.13463-5-brijesh.singh@amd.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/29/2017 11:54 AM, Singh, Brijesh wrote:
> CCP device initializes is now integerated into higher level SP device,
> to avoid the confusion lets rename the ccp driver initialization files
> (ccp-platform.c->sp-platform.c, ccp-pci.c->sp-pci.c). The patch does not
> make any functional changes other than renaming file and structures
>
> Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>

Acked-by: Gary R Hook <gary.hook@amd.com>

> ---
>  drivers/crypto/ccp/Makefile                        |  4 +-
>  drivers/crypto/ccp/ccp-dev.h                       |  6 --
>  drivers/crypto/ccp/sp-dev.c                        | 12 ++--
>  drivers/crypto/ccp/{ccp-pci.c => sp-pci.c}         | 80
> +++++++++++-----------
>  .../crypto/ccp/{ccp-platform.c => sp-platform.c}   | 78
> ++++++++++-----------
>  5 files changed, 87 insertions(+), 93 deletions(-)
>  rename drivers/crypto/ccp/{ccp-pci.c => sp-pci.c} (71%)
>  rename drivers/crypto/ccp/{ccp-platform.c => sp-platform.c} (66%)
>
> diff --git a/drivers/crypto/ccp/Makefile b/drivers/crypto/ccp/Makefile
> index d2f1b52..5f2adc5 100644
> --- a/drivers/crypto/ccp/Makefile
> +++ b/drivers/crypto/ccp/Makefile
> @@ -1,12 +1,12 @@
>  obj-$(CONFIG_CRYPTO_DEV_CCP_DD) += ccp.o
> -ccp-objs  := sp-dev.o ccp-platform.o
> +ccp-objs  := sp-dev.o sp-platform.o
>  ccp-$(CONFIG_CRYPTO_DEV_SP_CCP) += ccp-dev.o \
>              ccp-ops.o \
>              ccp-dev-v3.o \
>              ccp-dev-v5.o \
>              ccp-dmaengine.o \
>              ccp-debugfs.o
> -ccp-$(CONFIG_PCI) += ccp-pci.o
> +ccp-$(CONFIG_PCI) += sp-pci.o
>
>  obj-$(CONFIG_CRYPTO_DEV_CCP_CRYPTO) += ccp-crypto.o
>  ccp-crypto-objs := ccp-crypto-main.o \
> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
> index 193f309..b959e24 100644
> --- a/drivers/crypto/ccp/ccp-dev.h
> +++ b/drivers/crypto/ccp/ccp-dev.h
> @@ -626,12 +626,6 @@ struct ccp5_desc {
>          struct dword7 dw7;
>  };
>
> -int ccp_pci_init(void);
> -void ccp_pci_exit(void);
> -
> -int ccp_platform_init(void);
> -void ccp_platform_exit(void);
> -
>  void ccp_add_device(struct ccp_device *ccp);
>  void ccp_del_device(struct ccp_device *ccp);
>
> diff --git a/drivers/crypto/ccp/sp-dev.c b/drivers/crypto/ccp/sp-dev.c
> index 44e76e5..edbf1bd9 100644
> --- a/drivers/crypto/ccp/sp-dev.c
> +++ b/drivers/crypto/ccp/sp-dev.c
> @@ -240,13 +240,13 @@ static int __init sp_mod_init(void)
>  #ifdef CONFIG_X86
>          int ret;
>
> -       ret = ccp_pci_init();
> +       ret = sp_pci_init();
>          if (ret)
>                  return ret;
>
>          /* Don't leave the driver loaded if init failed */
>          if (ccp_present() != 0) {
> -               ccp_pci_exit();
> +               sp_pci_exit();
>                  return -ENODEV;
>          }
>
> @@ -256,13 +256,13 @@ static int __init sp_mod_init(void)
>  #ifdef CONFIG_ARM64
>          int ret;
>
> -       ret = ccp_platform_init();
> +       ret = sp_platform_init();
>          if (ret)
>                  return ret;
>
>          /* Don't leave the driver loaded if init failed */
>          if (ccp_present() != 0) {
> -               ccp_platform_exit();
> +               sp_platform_exit();
>                  return -ENODEV;
>          }
>
> @@ -275,11 +275,11 @@ static int __init sp_mod_init(void)
>  static void __exit sp_mod_exit(void)
>  {
>  #ifdef CONFIG_X86
> -       ccp_pci_exit();
> +       sp_pci_exit();
>  #endif
>
>  #ifdef CONFIG_ARM64
> -       ccp_platform_exit();
> +       sp_platform_exit();
>  #endif
>  }
>
> diff --git a/drivers/crypto/ccp/ccp-pci.c b/drivers/crypto/ccp/sp-pci.c
> similarity index 71%
> rename from drivers/crypto/ccp/ccp-pci.c
> rename to drivers/crypto/ccp/sp-pci.c
> index b29a093..9859aa6 100644
> --- a/drivers/crypto/ccp/ccp-pci.c
> +++ b/drivers/crypto/ccp/sp-pci.c
> @@ -1,5 +1,5 @@
>  /*
> - * AMD Cryptographic Coprocessor (CCP) driver
> + * AMD Secure Processor device driver
>   *
>   * Copyright (C) 2013,2016 Advanced Micro Devices, Inc.
>   *
> @@ -28,35 +28,35 @@
>
>  #define MSIX_VECTORS                    2
>
> -struct ccp_pci {
> +struct sp_pci {
>          int msix_count;
>          struct msix_entry msix_entry[MSIX_VECTORS];
>  };
>
> -static int ccp_get_msix_irqs(struct sp_device *sp)
> +static int sp_get_msix_irqs(struct sp_device *sp)
>  {
> -       struct ccp_pci *ccp_pci = sp->dev_specific;
> +       struct sp_pci *sp_pci = sp->dev_specific;
>          struct device *dev = sp->dev;
>          struct pci_dev *pdev = to_pci_dev(dev);
>          int v, ret;
>
> -       for (v = 0; v < ARRAY_SIZE(ccp_pci->msix_entry); v++)
> -               ccp_pci->msix_entry[v].entry = v;
> +       for (v = 0; v < ARRAY_SIZE(sp_pci->msix_entry); v++)
> +               sp_pci->msix_entry[v].entry = v;
>
> -       ret = pci_enable_msix_range(pdev, ccp_pci->msix_entry, 1, v);
> +       ret = pci_enable_msix_range(pdev, sp_pci->msix_entry, 1, v);
>          if (ret < 0)
>                  return ret;
>
> -       ccp_pci->msix_count = ret;
> +       sp_pci->msix_count = ret;
>          sp->use_tasklet = true;
>
> -       sp->psp_irq = ccp_pci->msix_entry[0].vector;
> -       sp->ccp_irq = (ccp_pci->msix_count > 1) ?
> ccp_pci->msix_entry[1].vector
> -                                              :
> ccp_pci->msix_entry[0].vector;
> +       sp->psp_irq = sp_pci->msix_entry[0].vector;
> +       sp->ccp_irq = (sp_pci->msix_count > 1) ?
> sp_pci->msix_entry[1].vector
> +                                              :
> sp_pci->msix_entry[0].vector;
>          return 0;
>  }
>
> -static int ccp_get_msi_irq(struct sp_device *sp)
> +static int sp_get_msi_irq(struct sp_device *sp)
>  {
>          struct device *dev = sp->dev;
>          struct pci_dev *pdev = to_pci_dev(dev);
> @@ -72,18 +72,18 @@ static int ccp_get_msi_irq(struct sp_device *sp)
>          return 0;
>  }
>
> -static int ccp_get_irqs(struct sp_device *sp)
> +static int sp_get_irqs(struct sp_device *sp)
>  {
>          struct device *dev = sp->dev;
>          int ret;
>
> -       ret = ccp_get_msix_irqs(sp);
> +       ret = sp_get_msix_irqs(sp);
>          if (!ret)
>                  return 0;
>
>          /* Couldn't get MSI-X vectors, try MSI */
>          dev_notice(dev, "could not enable MSI-X (%d), trying MSI\n", ret);
> -       ret = ccp_get_msi_irq(sp);
> +       ret = sp_get_msi_irq(sp);
>          if (!ret)
>                  return 0;
>
> @@ -93,13 +93,13 @@ static int ccp_get_irqs(struct sp_device *sp)
>          return ret;
>  }
>
> -static void ccp_free_irqs(struct sp_device *sp)
> +static void sp_free_irqs(struct sp_device *sp)
>  {
> -       struct ccp_pci *ccp_pci = sp->dev_specific;
> +       struct sp_pci *sp_pci = sp->dev_specific;
>          struct device *dev = sp->dev;
>          struct pci_dev *pdev = to_pci_dev(dev);
>
> -       if (ccp_pci->msix_count)
> +       if (sp_pci->msix_count)
>                  pci_disable_msix(pdev);
>          else if (sp->psp_irq)
>                  pci_disable_msi(pdev);
> @@ -108,10 +108,10 @@ static void ccp_free_irqs(struct sp_device *sp)
>          sp->psp_irq = 0;
>  }
>
> -static int ccp_pci_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
> +static int sp_pci_probe(struct pci_dev *pdev, const struct
> pci_device_id *id)
>  {
>          struct sp_device *sp;
> -       struct ccp_pci *ccp_pci;
> +       struct sp_pci *sp_pci;
>          struct device *dev = &pdev->dev;
>          void __iomem * const *iomap_table;
>          int bar_mask;
> @@ -122,11 +122,11 @@ static int ccp_pci_probe(struct pci_dev *pdev,
> const struct pci_device_id *id)
>          if (!sp)
>                  goto e_err;
>
> -       ccp_pci = devm_kzalloc(dev, sizeof(*ccp_pci), GFP_KERNEL);
> -       if (!ccp_pci)
> +       sp_pci = devm_kzalloc(dev, sizeof(*sp_pci), GFP_KERNEL);
> +       if (!sp_pci)
>                  goto e_err;
>
> -       sp->dev_specific = ccp_pci;
> +       sp->dev_specific = sp_pci;
>          sp->dev_vdata = (struct sp_dev_vdata *)id->driver_data;
>          if (!sp->dev_vdata) {
>                  ret = -ENODEV;
> @@ -161,7 +161,7 @@ static int ccp_pci_probe(struct pci_dev *pdev, const
> struct pci_device_id *id)
>                  goto e_err;
>          }
>
> -       ret = ccp_get_irqs(sp);
> +       ret = sp_get_irqs(sp);
>          if (ret)
>                  goto e_err;
>
> @@ -192,7 +192,7 @@ static int ccp_pci_probe(struct pci_dev *pdev, const
> struct pci_device_id *id)
>          return ret;
>  }
>
> -static void ccp_pci_remove(struct pci_dev *pdev)
> +static void sp_pci_remove(struct pci_dev *pdev)
>  {
>          struct device *dev = &pdev->dev;
>          struct sp_device *sp = dev_get_drvdata(dev);
> @@ -202,13 +202,13 @@ static void ccp_pci_remove(struct pci_dev *pdev)
>
>          sp_destroy(sp);
>
> -       ccp_free_irqs(sp);
> +       sp_free_irqs(sp);
>
>          dev_notice(dev, "disabled\n");
>  }
>
>  #ifdef CONFIG_PM
> -static int ccp_pci_suspend(struct pci_dev *pdev, pm_message_t state)
> +static int sp_pci_suspend(struct pci_dev *pdev, pm_message_t state)
>  {
>          struct device *dev = &pdev->dev;
>          struct sp_device *sp = dev_get_drvdata(dev);
> @@ -216,7 +216,7 @@ static int ccp_pci_suspend(struct pci_dev *pdev,
> pm_message_t state)
>          return sp_suspend(sp, state);
>  }
>
> -static int ccp_pci_resume(struct pci_dev *pdev)
> +static int sp_pci_resume(struct pci_dev *pdev)
>  {
>          struct device *dev = &pdev->dev;
>          struct sp_device *sp = dev_get_drvdata(dev);
> @@ -245,32 +245,32 @@ static const struct sp_dev_vdata dev_vdata[] = {
>  #endif
>          },
>  };
> -static const struct pci_device_id ccp_pci_table[] = {
> +static const struct pci_device_id sp_pci_table[] = {
>          { PCI_VDEVICE(AMD, 0x1537), (kernel_ulong_t)&dev_vdata[0] },
>          { PCI_VDEVICE(AMD, 0x1456), (kernel_ulong_t)&dev_vdata[1] },
>          { PCI_VDEVICE(AMD, 0x1468), (kernel_ulong_t)&dev_vdata[2] },
>          /* Last entry must be zero */
>          { 0, }
>  };
> -MODULE_DEVICE_TABLE(pci, ccp_pci_table);
> +MODULE_DEVICE_TABLE(pci, sp_pci_table);
>
> -static struct pci_driver ccp_pci_driver = {
> +static struct pci_driver sp_pci_driver = {
>          .name = "ccp",
> -       .id_table = ccp_pci_table,
> -       .probe = ccp_pci_probe,
> -       .remove = ccp_pci_remove,
> +       .id_table = sp_pci_table,
> +       .probe = sp_pci_probe,
> +       .remove = sp_pci_remove,
>  #ifdef CONFIG_PM
> -       .suspend = ccp_pci_suspend,
> -       .resume = ccp_pci_resume,
> +       .suspend = sp_pci_suspend,
> +       .resume = sp_pci_resume,
>  #endif
>  };
>
> -int ccp_pci_init(void)
> +int sp_pci_init(void)
>  {
> -       return pci_register_driver(&ccp_pci_driver);
> +       return pci_register_driver(&sp_pci_driver);
>  }
>
> -void ccp_pci_exit(void)
> +void sp_pci_exit(void)
>  {
> -       pci_unregister_driver(&ccp_pci_driver);
> +       pci_unregister_driver(&sp_pci_driver);
>  }
> diff --git a/drivers/crypto/ccp/ccp-platform.c
> b/drivers/crypto/ccp/sp-platform.c
> similarity index 66%
> rename from drivers/crypto/ccp/ccp-platform.c
> rename to drivers/crypto/ccp/sp-platform.c
> index 5228dd7..1785832 100644
> --- a/drivers/crypto/ccp/ccp-platform.c
> +++ b/drivers/crypto/ccp/sp-platform.c
> @@ -1,5 +1,5 @@
>  /*
> - * AMD Cryptographic Coprocessor (CCP) driver
> + * AMD Secure Processor device driver
>   *
>   * Copyright (C) 2014,2016 Advanced Micro Devices, Inc.
>   *
> @@ -28,41 +28,41 @@
>
>  #include "ccp-dev.h"
>
> -struct ccp_platform {
> +struct sp_platform {
>          int coherent;
>          unsigned int irq_count;
>  };
>
> -static const struct acpi_device_id ccp_acpi_match[];
> -static const struct of_device_id ccp_of_match[];
> +static const struct acpi_device_id sp_acpi_match[];
> +static const struct of_device_id sp_of_match[];
>
> -static struct sp_dev_vdata *ccp_get_of_version(struct platform_device
> *pdev)
> +static struct sp_dev_vdata *sp_get_of_version(struct platform_device *pdev)
>  {
>  #ifdef CONFIG_OF
>          const struct of_device_id *match;
>
> -       match = of_match_node(ccp_of_match, pdev->dev.of_node);
> +       match = of_match_node(sp_of_match, pdev->dev.of_node);
>          if (match && match->data)
>                  return (struct sp_dev_vdata *)match->data;
>  #endif
>          return NULL;
>  }
>
> -static struct sp_dev_vdata *ccp_get_acpi_version(struct platform_device
> *pdev)
> +static struct sp_dev_vdata *sp_get_acpi_version(struct platform_device
> *pdev)
>  {
>  #ifdef CONFIG_ACPI
>          const struct acpi_device_id *match;
>
> -       match = acpi_match_device(ccp_acpi_match, &pdev->dev);
> +       match = acpi_match_device(sp_acpi_match, &pdev->dev);
>          if (match && match->driver_data)
>                  return (struct sp_dev_vdata *)match->driver_data;
>  #endif
>          return NULL;
>  }
>
> -static int ccp_get_irqs(struct sp_device *sp)
> +static int sp_get_irqs(struct sp_device *sp)
>  {
> -       struct ccp_platform *ccp_platform = sp->dev_specific;
> +       struct sp_platform *sp_platform = sp->dev_specific;
>          struct device *dev = sp->dev;
>          struct platform_device *pdev = to_platform_device(dev);
>          unsigned int i, count;
> @@ -75,7 +75,7 @@ static int ccp_get_irqs(struct sp_device *sp)
>                          count++;
>          }
>
> -       ccp_platform->irq_count = count;
> +       sp_platform->irq_count = count;
>
>          ret = platform_get_irq(pdev, 0);
>          if (ret < 0)
> @@ -95,10 +95,10 @@ static int ccp_get_irqs(struct sp_device *sp)
>          return 0;
>  }
>
> -static int ccp_platform_probe(struct platform_device *pdev)
> +static int sp_platform_probe(struct platform_device *pdev)
>  {
>          struct sp_device *sp;
> -       struct ccp_platform *ccp_platform;
> +       struct sp_platform *sp_platform;
>          struct device *dev = &pdev->dev;
>          enum dev_dma_attr attr;
>          struct resource *ior;
> @@ -109,13 +109,13 @@ static int ccp_platform_probe(struct
> platform_device *pdev)
>          if (!sp)
>                  goto e_err;
>
> -       ccp_platform = devm_kzalloc(dev, sizeof(*ccp_platform), GFP_KERNEL);
> -       if (!ccp_platform)
> +       sp_platform = devm_kzalloc(dev, sizeof(*sp_platform), GFP_KERNEL);
> +       if (!sp_platform)
>                  goto e_err;
>
> -       sp->dev_specific = ccp_platform;
> -       sp->dev_vdata = pdev->dev.of_node ? ccp_get_of_version(pdev)
> -                                        : ccp_get_acpi_version(pdev);
> +       sp->dev_specific = sp_platform;
> +       sp->dev_vdata = pdev->dev.of_node ? sp_get_of_version(pdev)
> +                                        : sp_get_acpi_version(pdev);
>          if (!sp->dev_vdata) {
>                  ret = -ENODEV;
>                  dev_err(dev, "missing driver data\n");
> @@ -135,8 +135,8 @@ static int ccp_platform_probe(struct platform_device
> *pdev)
>                  goto e_err;
>          }
>
> -       ccp_platform->coherent = (attr == DEV_DMA_COHERENT);
> -       if (ccp_platform->coherent)
> +       sp_platform->coherent = (attr == DEV_DMA_COHERENT);
> +       if (sp_platform->coherent)
>                  sp->axcache = CACHE_WB_NO_ALLOC;
>          else
>                  sp->axcache = CACHE_NONE;
> @@ -147,7 +147,7 @@ static int ccp_platform_probe(struct platform_device
> *pdev)
>                  goto e_err;
>          }
>
> -       ret = ccp_get_irqs(sp);
> +       ret = sp_get_irqs(sp);
>          if (ret)
>                  goto e_err;
>
> @@ -166,7 +166,7 @@ static int ccp_platform_probe(struct platform_device
> *pdev)
>          return ret;
>  }
>
> -static int ccp_platform_remove(struct platform_device *pdev)
> +static int sp_platform_remove(struct platform_device *pdev)
>  {
>          struct device *dev = &pdev->dev;
>          struct sp_device *sp = dev_get_drvdata(dev);
> @@ -179,7 +179,7 @@ static int ccp_platform_remove(struct
> platform_device *pdev)
>  }
>
>  #ifdef CONFIG_PM
> -static int ccp_platform_suspend(struct platform_device *pdev,
> +static int sp_platform_suspend(struct platform_device *pdev,
>                                  pm_message_t state)
>  {
>          struct device *dev = &pdev->dev;
> @@ -188,7 +188,7 @@ static int ccp_platform_suspend(struct
> platform_device *pdev,
>          return sp_suspend(sp, state);
>  }
>
> -static int ccp_platform_resume(struct platform_device *pdev)
> +static int sp_platform_resume(struct platform_device *pdev)
>  {
>          struct device *dev = &pdev->dev;
>          struct sp_device *sp = dev_get_drvdata(dev);
> @@ -207,46 +207,46 @@ static const struct sp_dev_vdata dev_vdata[] = {
>  };
>
>  #ifdef CONFIG_ACPI
> -static const struct acpi_device_id ccp_acpi_match[] = {
> +static const struct acpi_device_id sp_acpi_match[] = {
>          { "AMDI0C00", (kernel_ulong_t)&dev_vdata[0] },
>          { },
>  };
> -MODULE_DEVICE_TABLE(acpi, ccp_acpi_match);
> +MODULE_DEVICE_TABLE(acpi, sp_acpi_match);
>  #endif
>
>  #ifdef CONFIG_OF
> -static const struct of_device_id ccp_of_match[] = {
> +static const struct of_device_id sp_of_match[] = {
>          { .compatible = "amd,ccp-seattle-v1a",
>            .data = (const void *)&dev_vdata[0] },
>          { },
>  };
> -MODULE_DEVICE_TABLE(of, ccp_of_match);
> +MODULE_DEVICE_TABLE(of, sp_of_match);
>  #endif
>
> -static struct platform_driver ccp_platform_driver = {
> +static struct platform_driver sp_platform_driver = {
>          .driver = {
>                  .name = "ccp",
>  #ifdef CONFIG_ACPI
> -               .acpi_match_table = ccp_acpi_match,
> +               .acpi_match_table = sp_acpi_match,
>  #endif
>  #ifdef CONFIG_OF
> -               .of_match_table = ccp_of_match,
> +               .of_match_table = sp_of_match,
>  #endif
>          },
> -       .probe = ccp_platform_probe,
> -       .remove = ccp_platform_remove,
> +       .probe = sp_platform_probe,
> +       .remove = sp_platform_remove,
>  #ifdef CONFIG_PM
> -       .suspend = ccp_platform_suspend,
> -       .resume = ccp_platform_resume,
> +       .suspend = sp_platform_suspend,
> +       .resume = sp_platform_resume,
>  #endif
>  };
>
> -int ccp_platform_init(void)
> +int sp_platform_init(void)
>  {
> -       return platform_driver_register(&ccp_platform_driver);
> +       return platform_driver_register(&sp_platform_driver);
>  }
>
> -void ccp_platform_exit(void)
> +void sp_platform_exit(void)
>  {
> -       platform_driver_unregister(&ccp_platform_driver);
> +       platform_driver_unregister(&sp_platform_driver);
>  }
> --
> 2.9.4
>
