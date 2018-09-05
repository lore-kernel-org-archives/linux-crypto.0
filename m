From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 3/7] vfio: add sdmdev support
Date: Wed, 5 Sep 2018 10:27:37 +0300
Message-ID: <20180905072737.figussnuhdtlbnee@mwanda>
References: <20180903005204.26041-4-nek.in.cn@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org,
 Zaibo Xu <xuzaibo@huawei.com>, Sanjay Kumar <sanjay.k.kumar@intel.com>,
 linuxarm@huawei.com, Hao Fang <fanghao11@huawei.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, Jonathan Corbet <corbet@lwn.net>,
 Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org,
 linux-crypto@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 Zhou Wang <wangzhou1@hisilicon.com>, kbuild-all@01.org,
 Philippe Ombredanne <pombredanne@nexb.com>,
 Kenneth Lee <liguozhu@hisilicon.com>, "David S . Miller" <davem@davemloft.net>,
 linux-accelerators@lists.ozlabs.org, Lu Baolu <baolu.lu@linux.intel.com>
To: kbuild@01.org, Kenneth Lee <nek.in.cn@gmail.com>
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20180903005204.26041-4-nek.in.cn@gmail.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
List-Id: linux-crypto.vger.kernel.org

Hi Kenneth,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cryptodev/master]
[also build test WARNING on v4.19-rc2 next-20180905]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Kenneth-Lee/A-General-Accelerator-Framework-WarpDrive/20180903-162733
base:   https://git.kernel.org/pub/scm/linux/kernel/git/herbert/cryptodev-2.6.git master

smatch warnings:
drivers/vfio/sdmdev/vfio_sdmdev.c:78 iommu_type_show() error: 'sdmdev' dereferencing possible ERR_PTR()
drivers/vfio/sdmdev/vfio_sdmdev.c:91 dma_flag_show() error: 'sdmdev' dereferencing possible ERR_PTR()
drivers/vfio/sdmdev/vfio_sdmdev.c:127 flags_show() error: 'sdmdev' dereferencing possible ERR_PTR()
drivers/vfio/sdmdev/vfio_sdmdev.c:128 name_show() error: 'sdmdev' dereferencing possible ERR_PTR()
drivers/vfio/sdmdev/vfio_sdmdev.c:130 device_api_show() error: 'sdmdev' dereferencing possible ERR_PTR()
drivers/vfio/sdmdev/vfio_sdmdev.c:138 available_instances_show() error: 'sdmdev' dereferencing possible ERR_PTR()
drivers/vfio/sdmdev/vfio_sdmdev.c:178 vfio_sdmdev_mdev_remove() warn: if();

# https://github.com/0day-ci/linux/commit/1e47d5e608652b4a2c813dbeaf5aa6811f6ceaf7
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 1e47d5e608652b4a2c813dbeaf5aa6811f6ceaf7
vim +/sdmdev +78 drivers/vfio/sdmdev/vfio_sdmdev.c

1e47d5e6 Kenneth Lee 2018-09-03   69  
1e47d5e6 Kenneth Lee 2018-09-03   70  static ssize_t iommu_type_show(struct device *dev,
1e47d5e6 Kenneth Lee 2018-09-03   71  			       struct device_attribute *attr, char *buf)
1e47d5e6 Kenneth Lee 2018-09-03   72  {
1e47d5e6 Kenneth Lee 2018-09-03   73  	struct vfio_sdmdev *sdmdev = vfio_sdmdev_pdev_sdmdev(dev);
                                                                     ^^^^^^^^^^^^^^^^^^^^^^^
Presumably this returns error pointers instead of NULL?

1e47d5e6 Kenneth Lee 2018-09-03   74  
1e47d5e6 Kenneth Lee 2018-09-03   75  	if (!sdmdev)
1e47d5e6 Kenneth Lee 2018-09-03   76  		return -ENODEV;
1e47d5e6 Kenneth Lee 2018-09-03   77  
1e47d5e6 Kenneth Lee 2018-09-03  @78  	return sprintf(buf, "%d\n", sdmdev->iommu_type);
1e47d5e6 Kenneth Lee 2018-09-03   79  }
1e47d5e6 Kenneth Lee 2018-09-03   80  
1e47d5e6 Kenneth Lee 2018-09-03   81  static DEVICE_ATTR_RO(iommu_type);
1e47d5e6 Kenneth Lee 2018-09-03   82  
1e47d5e6 Kenneth Lee 2018-09-03   83  static ssize_t dma_flag_show(struct device *dev,
1e47d5e6 Kenneth Lee 2018-09-03   84  			     struct device_attribute *attr, char *buf)
1e47d5e6 Kenneth Lee 2018-09-03   85  {
1e47d5e6 Kenneth Lee 2018-09-03   86  	struct vfio_sdmdev *sdmdev = vfio_sdmdev_pdev_sdmdev(dev);
1e47d5e6 Kenneth Lee 2018-09-03   87  
1e47d5e6 Kenneth Lee 2018-09-03   88  	if (!sdmdev)
1e47d5e6 Kenneth Lee 2018-09-03   89  		return -ENODEV;
1e47d5e6 Kenneth Lee 2018-09-03   90  
1e47d5e6 Kenneth Lee 2018-09-03  @91  	return sprintf(buf, "%d\n", sdmdev->dma_flag);
1e47d5e6 Kenneth Lee 2018-09-03   92  }
1e47d5e6 Kenneth Lee 2018-09-03   93  
1e47d5e6 Kenneth Lee 2018-09-03   94  static DEVICE_ATTR_RO(dma_flag);
1e47d5e6 Kenneth Lee 2018-09-03   95  
1e47d5e6 Kenneth Lee 2018-09-03   96  /* mdev->dev_attr_groups */
1e47d5e6 Kenneth Lee 2018-09-03   97  static struct attribute *vfio_sdmdev_attrs[] = {
1e47d5e6 Kenneth Lee 2018-09-03   98  	&dev_attr_iommu_type.attr,
1e47d5e6 Kenneth Lee 2018-09-03   99  	&dev_attr_dma_flag.attr,
1e47d5e6 Kenneth Lee 2018-09-03  100  	NULL,
1e47d5e6 Kenneth Lee 2018-09-03  101  };
1e47d5e6 Kenneth Lee 2018-09-03  102  static const struct attribute_group vfio_sdmdev_group = {
1e47d5e6 Kenneth Lee 2018-09-03  103  	.name  = VFIO_SDMDEV_PDEV_ATTRS_GRP_NAME,
1e47d5e6 Kenneth Lee 2018-09-03  104  	.attrs = vfio_sdmdev_attrs,
1e47d5e6 Kenneth Lee 2018-09-03  105  };
1e47d5e6 Kenneth Lee 2018-09-03  106  const struct attribute_group *vfio_sdmdev_groups[] = {
1e47d5e6 Kenneth Lee 2018-09-03  107  	&vfio_sdmdev_group,
1e47d5e6 Kenneth Lee 2018-09-03  108  	NULL,
1e47d5e6 Kenneth Lee 2018-09-03  109  };
1e47d5e6 Kenneth Lee 2018-09-03  110  
1e47d5e6 Kenneth Lee 2018-09-03  111  /* default attributes for mdev->supported_type_groups, used by registerer*/
1e47d5e6 Kenneth Lee 2018-09-03  112  #define MDEV_TYPE_ATTR_RO_EXPORT(name) \
1e47d5e6 Kenneth Lee 2018-09-03  113  		MDEV_TYPE_ATTR_RO(name); \
1e47d5e6 Kenneth Lee 2018-09-03  114  		EXPORT_SYMBOL_GPL(mdev_type_attr_##name);
1e47d5e6 Kenneth Lee 2018-09-03  115  
1e47d5e6 Kenneth Lee 2018-09-03  116  #define DEF_SIMPLE_SDMDEV_ATTR(_name, sdmdev_member, format) \
1e47d5e6 Kenneth Lee 2018-09-03  117  static ssize_t _name##_show(struct kobject *kobj, struct device *dev, \
1e47d5e6 Kenneth Lee 2018-09-03  118  			    char *buf) \
1e47d5e6 Kenneth Lee 2018-09-03  119  { \
1e47d5e6 Kenneth Lee 2018-09-03  120  	struct vfio_sdmdev *sdmdev = vfio_sdmdev_pdev_sdmdev(dev); \
1e47d5e6 Kenneth Lee 2018-09-03  121  	if (!sdmdev) \
1e47d5e6 Kenneth Lee 2018-09-03  122  		return -ENODEV; \
1e47d5e6 Kenneth Lee 2018-09-03  123  	return sprintf(buf, format, sdmdev->sdmdev_member); \
1e47d5e6 Kenneth Lee 2018-09-03  124  } \
1e47d5e6 Kenneth Lee 2018-09-03  125  MDEV_TYPE_ATTR_RO_EXPORT(_name)
1e47d5e6 Kenneth Lee 2018-09-03  126  
1e47d5e6 Kenneth Lee 2018-09-03 @127  DEF_SIMPLE_SDMDEV_ATTR(flags, flags, "%d");
1e47d5e6 Kenneth Lee 2018-09-03 @128  DEF_SIMPLE_SDMDEV_ATTR(name, name, "%s"); /* this should be algorithm name, */
1e47d5e6 Kenneth Lee 2018-09-03  129  		/* but you would not care if you have only one algorithm */
1e47d5e6 Kenneth Lee 2018-09-03 @130  DEF_SIMPLE_SDMDEV_ATTR(device_api, api_ver, "%s");
1e47d5e6 Kenneth Lee 2018-09-03  131  
1e47d5e6 Kenneth Lee 2018-09-03  132  static ssize_t
1e47d5e6 Kenneth Lee 2018-09-03  133  available_instances_show(struct kobject *kobj, struct device *dev, char *buf)
1e47d5e6 Kenneth Lee 2018-09-03  134  {
1e47d5e6 Kenneth Lee 2018-09-03  135  	struct vfio_sdmdev *sdmdev = vfio_sdmdev_pdev_sdmdev(dev);
1e47d5e6 Kenneth Lee 2018-09-03  136  	int nr_inst = 0;
1e47d5e6 Kenneth Lee 2018-09-03  137  
1e47d5e6 Kenneth Lee 2018-09-03 @138  	nr_inst = sdmdev->ops->get_available_instances ?
1e47d5e6 Kenneth Lee 2018-09-03  139  		sdmdev->ops->get_available_instances(sdmdev) : 0;
1e47d5e6 Kenneth Lee 2018-09-03  140  	return sprintf(buf, "%d", nr_inst);
1e47d5e6 Kenneth Lee 2018-09-03  141  }
1e47d5e6 Kenneth Lee 2018-09-03  142  MDEV_TYPE_ATTR_RO_EXPORT(available_instances);
1e47d5e6 Kenneth Lee 2018-09-03  143  
1e47d5e6 Kenneth Lee 2018-09-03  144  static int vfio_sdmdev_mdev_create(struct kobject *kobj,
1e47d5e6 Kenneth Lee 2018-09-03  145  	struct mdev_device *mdev)
1e47d5e6 Kenneth Lee 2018-09-03  146  {
1e47d5e6 Kenneth Lee 2018-09-03  147  	struct device *pdev = mdev_parent_dev(mdev);
1e47d5e6 Kenneth Lee 2018-09-03  148  	struct vfio_sdmdev_queue *q;
1e47d5e6 Kenneth Lee 2018-09-03  149  	struct vfio_sdmdev *sdmdev = mdev_sdmdev(mdev);
1e47d5e6 Kenneth Lee 2018-09-03  150  	int ret;
1e47d5e6 Kenneth Lee 2018-09-03  151  
1e47d5e6 Kenneth Lee 2018-09-03  152  	if (!sdmdev->ops->get_queue)
1e47d5e6 Kenneth Lee 2018-09-03  153  		return -ENODEV;
1e47d5e6 Kenneth Lee 2018-09-03  154  
1e47d5e6 Kenneth Lee 2018-09-03  155  	ret = sdmdev->ops->get_queue(sdmdev, &q);
1e47d5e6 Kenneth Lee 2018-09-03  156  	if (ret)
1e47d5e6 Kenneth Lee 2018-09-03  157  		return ret;
1e47d5e6 Kenneth Lee 2018-09-03  158  
1e47d5e6 Kenneth Lee 2018-09-03  159  	q->sdmdev = sdmdev;
1e47d5e6 Kenneth Lee 2018-09-03  160  	q->mdev = mdev;
1e47d5e6 Kenneth Lee 2018-09-03  161  	init_waitqueue_head(&q->wait);
1e47d5e6 Kenneth Lee 2018-09-03  162  
1e47d5e6 Kenneth Lee 2018-09-03  163  	mdev_set_drvdata(mdev, q);
1e47d5e6 Kenneth Lee 2018-09-03  164  	get_device(pdev);
1e47d5e6 Kenneth Lee 2018-09-03  165  
1e47d5e6 Kenneth Lee 2018-09-03  166  	return 0;
1e47d5e6 Kenneth Lee 2018-09-03  167  }
1e47d5e6 Kenneth Lee 2018-09-03  168  
1e47d5e6 Kenneth Lee 2018-09-03  169  static int vfio_sdmdev_mdev_remove(struct mdev_device *mdev)
1e47d5e6 Kenneth Lee 2018-09-03  170  {
1e47d5e6 Kenneth Lee 2018-09-03  171  	struct vfio_sdmdev_queue *q =
1e47d5e6 Kenneth Lee 2018-09-03  172  		(struct vfio_sdmdev_queue *)mdev_get_drvdata(mdev);
1e47d5e6 Kenneth Lee 2018-09-03  173  	struct vfio_sdmdev *sdmdev = q->sdmdev;
1e47d5e6 Kenneth Lee 2018-09-03  174  	struct device *pdev = mdev_parent_dev(mdev);
1e47d5e6 Kenneth Lee 2018-09-03  175  
1e47d5e6 Kenneth Lee 2018-09-03  176  	put_device(pdev);
1e47d5e6 Kenneth Lee 2018-09-03  177  
1e47d5e6 Kenneth Lee 2018-09-03 @178  	if (sdmdev->ops->put_queue);
                                                                   ^
Extra semicolon breaks the code.

1e47d5e6 Kenneth Lee 2018-09-03  179  		sdmdev->ops->put_queue(q);
1e47d5e6 Kenneth Lee 2018-09-03  180  
1e47d5e6 Kenneth Lee 2018-09-03  181  	return 0;
1e47d5e6 Kenneth Lee 2018-09-03  182  }
1e47d5e6 Kenneth Lee 2018-09-03  183  
